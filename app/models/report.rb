# == Schema Information
#
# Table name: reports
#
#  id                 :integer          not null, primary key
#  name               :string
#  sql                :text
#  regular_expression :text
#  source_id          :integer
#  observations_type  :integer          default(0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Report < ActiveRecord::Base
  include Connection
  
  # database validations
  validates :name, :sql, :source_id, :observations_type, presence: true, if: :is_database?

  # file validations
  validates :name, :regular_expression, :source_id, :observations_type, presence: true, if: :is_file?

  # on empty source
  validates :name, :sql, :regular_expression, :source_id, :observations_type, presence: true, if: :is_nothing?
  
  module ObservationsType
    NONE = 0
    YEAR = 1
    MONTH = 2
    DAY = 3
    
    ALL = [['STANDARD', NONE], ['LESS', YEAR], ['MEDIUM', MONTH], ['MORE', DAY]]
  end
  
  module RangeType
    DISABLED = 0
    YEAR_BEGINING = 1
    MONTH_BEGINING = 2
    WEEK_BEGINING = 3
    DAY_BEGINING = 4
    HOUR_BEGINING = 5
    FROM_DATE_TO_NOW = 6
    LAST_HOUR = 7
    LAST_DAY = 8
    LAST_WEEK = 9
    LAST_MONTH = 10
    LAST_YEAR = 11
    LAST_NUMBER_OF_DAYS = 12

    ALL = [
      ['', DISABLED],
      ['This year begining', YEAR_BEGINING],
      ['This month begining', MONTH_BEGINING],
      ['This week begining', WEEK_BEGINING],
      ['This day begining', DAY_BEGINING],
      ['This hour begining', HOUR_BEGINING],
      ['From date to now', FROM_DATE_TO_NOW],
      ['Last hour', LAST_HOUR],
      ['Last day', LAST_DAY],
      ['Last week', LAST_WEEK],
      ['Last month', LAST_MONTH],
      ['Last year', LAST_YEAR],
      ['Last number of days', LAST_NUMBER_OF_DAYS]
    ]
  end
  
  has_many :execute_details, as: :executable
  belongs_to :source
  after_commit :create_observations, on: [:create, :update]
  after_destroy :drop_observations_table
  has_one :scheduler, :dependent => :destroy
  
  enum range: {
    disabled: RangeType::DISABLED,
    year_begining: RangeType::YEAR_BEGINING,
    month_begining: RangeType::MONTH_BEGINING,
    week_begining: RangeType::WEEK_BEGINING,
    day_begining: RangeType::DAY_BEGINING,
    hour_begining: RangeType::HOUR_BEGINING,
    from_date_to_current: RangeType::FROM_DATE_TO_NOW,
    last_hour: RangeType::LAST_HOUR,
    last_day: RangeType::LAST_DAY,
    last_week: RangeType::LAST_WEEK,
    last_month: RangeType::LAST_MONTH,
    last_year: RangeType::LAST_YEAR,
    last_number_of_days: RangeType::LAST_NUMBER_OF_DAYS,
    workdays: 14, #
    weekends: 15, #
    all_workdays: 16, #vse tolko rabochie dni v etom godu
    all_weekends: 17, #vse sub/voskr v etom godu
    all_holidays: 18, #tolko vyhodnye
    date_range: 19, #mejdu dvumya datami
    shifted_by_year: 20, #ot sdvinutogo kolichestva dney na odin god
    shifted_by_month: 22,
    shifted_by_week: 23,
    shifted_by_day: 24,
    shifted_by_hour: 25,
    shifted_by_days_count: 26, #s #19 na ustanovlennoe kolvo dnei
  }
  
  def observations_type_name
    ObservationsType::ALL.map {|t| t[1] === self.observations_type ? t[0] : nil}.compact[0] rescue "undefined"
  end


  def store(observations)
    suffix = dedicate_observations_space
    
    rows = observations['data']
    while rows.size > 0
      rows_block = rows.shift(5)
      sql = "INSERT INTO report_#{self.id}#{suffix}_observations (#{observations['columns'].join(', ')}) VALUES "

      items = []
      rows_block.each do |block|
        if self.source.use_database?
          items << "(" + block.values.map{|value| 
            value = '' if value.nil?

            ActiveRecord::Base.connection.quote(value.slice(0..254).to_s)
          }.join(", ") + ")"
        elsif self.source.use_file?
          items << "(" + block.map{|value| 
            value = '' if value.nil?
            string = value.chomp.slice(0..254).to_s

            ActiveRecord::Base.connection.quote(string)
          }.join(", ") + ")"
        end
      end
      sql << items.join(', ')
      
      ActiveRecord::Base.connection.exec_query(sql)
    end
  end

  def observations(**settings)
    limits = ''
    if settings.has_key?(:limit)
      limits = "LIMIT #{settings[:limit]}" if settings[:limit] != 'NO'
    end
    
    tables = observations_tables.map {|table| "SELECT * FROM #{table}"}
    sql = "SELECT * FROM (" + tables.join(' UNION ') + ") AS main #{limits}"
    
    ActiveRecord::Base.connection.exec_query(sql)
  end
  
  def self.convert_macros(report_regular_expression)
    #FORMAT='%Y-%m-%d' DATE=TODAY RANGE=604800,0,3600
    #FORMAT='%Y-%m-%d' DATE=TODAY MINUS=30
    #DATE=YESTERDAY
    
    date = nil
    format = '%Y-%m-%d'
    minus = 0
    
    regexp = Regexp.new("(.*)\#(.+?)\#(.*)")
    
    if matched = report_regular_expression.match(regexp)
      parameters = matched[2]
      
      if matched_date = parameters.match(/DATE\s*=\s*(TODAY|YESTERDAY)/)
        if matched_date[1] == 'TODAY'
          date = Time.now
        elsif matched_date[1] == 'YESTERDAY'
          date = Time.now - 1.day
        end
      end

      if matched_format = parameters.match(/FORMAT\s*=\s*'(.+?)'/)
        format = matched_format[1]
      end

      if matched_minus = parameters.match(/MINUS\s*=\s*(\d+)/)
        minus = matched_minus[1].to_i
      end

      macros = ""
      unless date.nil?
        macros = if matched_range = parameters.match(/RANGE\s*=\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)/)
          range_items = []
          ranges = ((date - matched_range[1].to_i - minus).to_i..(date - matched_range[2].to_i - minus).to_i).step(matched_range[3].to_i).to_a
          ranges.each do |item|
            range_items << Time.at(item).strftime(format)
          end
          '(' + range_items.uniq.join('|') + ')'
        else
          (date - minus).strftime(format)
        end
      end

      return matched[1] + macros + matched[3]
    end
    
    return report_regular_expression
  end
  
  def self.not_in_scheduler
    Report.where.not(id: Scheduler.all.map(&:report_id))
  end
  
  private
  def generate_suffix(type)
    case type
    when ObservationsType::YEAR
      '_' + Time.now.strftime("%Y")
    when ObservationsType::MONTH
      '_' + Time.now.strftime("%Y%m")
    when ObservationsType::DAY
      '_' + Time.now.strftime("%Y%m%d")
    else
      ''
    end
  end
  
  def dedicate_observations_space
    suffix = generate_suffix(self.observations_type)
    
    unless suffix.empty?
      unless observations_tables.any? {|table| table.include?(suffix)}
        observations = self.execute(false)
        create_observations_table(observations['columns'], self.observations_type)
      end
    end
    
    suffix
  end
  
  def create_observations
    drop_observations_table
    observations = self.execute(false)
    create_observations_table(observations['columns'], self.observations_type)
  end
  
  def create_observations_table(columns, type = ObservationsType::NONE)
    suffix = generate_suffix(type)
    
    sql = "CREATE TABLE IF NOT EXISTS report_#{self.id}#{suffix}_observations (" \
      "#{columns.map{|column| column + " VARCHAR(255)"}.join(',')}" \
    ")"

    ActiveRecord::Base.connection.exec_query(sql)
  end
  
  def drop_observations_table
    tables = ActiveRecord::Base.connection.tables
    tables.each do |table|
      if table.include?("report_#{self.id}_")
        ActiveRecord::Base.connection.exec_query("DROP TABLE IF EXISTS #{table}")
      end
    end
  end
  
  def observations_tables
    ActiveRecord::Base.connection.tables.keep_if {|table| table.include?("report_#{self.id}_")}
  end
  
  def is_database?
    (self.source.destination == Source::DESTINATIONS[0]) rescue false
  end
  
  def is_file?
    (self.source.destination == Source::DESTINATIONS[1]) rescue false
  end
  
  def is_nothing?
    self.source.nil?
  end
end
