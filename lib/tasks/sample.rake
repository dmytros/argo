namespace :sample do
  ROWS_COUNT =  24 * 365

  desc 'Load sample data'
  task :load => :environment do
    generate_data
#    generate_sources
#    generate_reports
#    load_data
  end

  def generate_data
    cisco
  end

  def generate_sources
    unless Source.exists?(name: 'Argos Cisco Sample Data Source')
      Source.create(name: 'Argos Cisco Sample Data Source', destination: 'file', path: File.join(Rails.root, 'db', 'cisco.sample'))
    end
  end

  def generate_reports
    unless Report.exists?(name: 'Argos Cisco Sample Data Report')
      source = Source.where(name: 'Argos Cisco Sample Data Source').first
      Report.create(name: 'Argos Cisco Sample Data Report', source_id: source.id, regular_expression: 'NETFLOW:\s+(\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}\.\d{3})\s+(\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}\.\d{3})\s+(\d+\.\d+)\s+([A-Z]+)\s+(\d{,3}\.\d{,3}\.\d{,3}\.\d{,3}):(\d+)\s+->\s+(\d{,3}\.\d{,3}\.\d{,3}\.\d{,3}):(\d+).*?\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(.+?)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)', observations_type: 0)
    end
  end

  def load_data
    samples = Report.where(['name LIKE ?', 'Argos % Sample Data Report'])
    for sample in samples
      observations = sample.execute
      sample.store(observations)
    end
  end

  private
  def cisco
    now = Time.now.beginning_of_hour - 365.days

    f = File.open(File.join(Rails.root, 'db', 'cisco.sample'), 'w+')
    shifted = 0
    ROWS_COUNT.times do |i|
      minutes = rand(5..55).minutes
      record = []

      record << 'NETFLOW:'
      started_at = now + shifted.hours + minutes
      record << started_at.strftime('%Y-%m-%d %H:%M:%S.%3N')
      finished_at = now + shifted.hours + minutes + rand(5).seconds
      record << finished_at.strftime('%Y-%m-%d %H:%M:%S.%3N')
      record << '%.3f' % (finished_at - started_at)
      record << ['TCP', 'UDP', 'ICMP'][rand(3)]
      record << Array.new(4) {rand(256)}.join('.') + ':' + rand(65536).to_s
      record << '->'
      record << Array.new(4) {rand(256)}.join('.') + ':' + rand(65536).to_s
      record << 0 << 0 << 4 << rand(65536) << '......' << 0 << 0 << 0 << 0 << 0 << 0 << 1

      shifted += 1
      f.puts record.join(' ')
    end
    f.close
  end
end
