module Connection
  include ApplicationHelper
  
  def tables
    begin
      excluded = ['created_at', 'updated_at', 'id', 'name', 'destination', 'path']

      source_attributes = self.attributes.except(*excluded)
      ActiveRecord::Base.establish_connection(filter_source_attributes(source_attributes))
      
      rows = []
      ActiveRecord::Base.connection.tables.each { |table| 
        ActiveRecord::Base.connection.columns(table).each { |column| 
          rows << {
            'table_name' => table, 
            'column_name' => column.name, 
            'data_type' => column.type.to_s
          }
        }
      }
      formated_output_tables(name, 'ok', '', rows, 0.0)
    rescue Exception => e
      formated_output(name, 'fail', e.message, [], 0.0)
    ensure
      ActiveRecord::Base.establish_connection(Rails.env.to_sym)
    end
  end
  
  def ping
    begin
      excluded = ['created_at', 'updated_at', 'id', 'name', 'destination', 'path']

      source_attributes = self.attributes.except(*excluded)
      ActiveRecord::Base.establish_connection(filter_source_attributes(source_attributes))
      data = ActiveRecord::Base.connection.exec_query('SELECT 1')

      formated_output(name, 'ok', '', data, 0.0)
    rescue Exception => e
      formated_output(name, 'fail', e.message, [], 0.0)
    ensure
      ActiveRecord::Base.establish_connection(Rails.env.to_sym)
    end
  end
  
  def execute(push_details = true)
    begin
      unless self.source.nil?
        if self.source.destination == Source::DESTINATIONS[Source::DATABASE]
          begin
            excluded = ['created_at', 'updated_at', 'id', 'name', 'destination', 'path']
            is_success = true
            msg = nil

            started_at = Time.now.to_f
            source_attributes = self.source.attributes.except(*excluded)
            ActiveRecord::Base.establish_connection(filter_source_attributes(source_attributes))

            data = ActiveRecord::Base.connection.exec_query(Report.convert_macros(sql))

            finished_at = Time.now.to_f

            formated_output(name, 'ok', '', data, finished_at - started_at)
          rescue Exception => e
            is_success = false
            msg = e.message
            formated_output(name, 'fail', e.message, [], 0.0)
          ensure
            ActiveRecord::Base.establish_connection(Rails.env.to_sym)

            if (push_details)
              push_details((data.count rescue 0), (finished_at - started_at rescue 0), is_success, msg)
            end
          end
        elsif self.source.destination == Source::DESTINATIONS[Source::FILE]
          begin
            is_success = true
            msg = nil

            started_at = Time.now.to_f

            regexp = Regexp.new(Report.convert_macros(self.regular_expression))
            fp = File.open(self.source.path)
            data = []
            fp.each_line do |row|
              if matched = row.match(regexp)
                data << matched[1..-1]
              end
            end
            fp.close

            columns = []
            data.first.each_with_index {|item, index| columns << "column#{index}"}

            finished_at = Time.now.to_f

            formated_output(name, 'ok', '', data, finished_at - started_at, true, columns)
          rescue Exception => e
            is_success = false
            msg = e.message
            formated_output(name, 'fail', e.message, [], 0.0)
          ensure
            if (push_details)
              push_details((data.count rescue 0), (finished_at - started_at rescue 0), is_success, msg)
            end
          end
        end
      else
        formated_output(name, 'fail', 'No Source selected', [], 0.0)
      end
    rescue Exception => e
      is_success = false
      msg = e.message
      formated_output(name, 'fail', e.message, [], 0.0)
    end
  end
  
  private
  def push_details(rows, spent_time, is_success = true, msg = nil)
    ExecuteDetail.create(
      name: 'manually', 
      rows_count: rows, 
      spent_time: spent_time, 
      is_success: is_success, 
      executable: self,
      message: msg)
  end
  
  def formated_output(name, status, message, data, elapsed_time, is_file = false, columns = [])
    output = {'name' => name, 'columns' => [], 'rows' => 0, 'elapsed_time' => 0.0, 'data' => [], 'status' => '', 'message' => ''}

    output['elapsed_time'] = spent_time_tag(elapsed_time)
    output['status'] = status
    output['message'] = message
    unless is_file
      output['data'] = data.collect {|item| item}
      output['columns'] = data.columns rescue []
    else
      output['data'] = data
      output['columns'] = columns
    end
    output['types'] = data.column_types rescue []
    output['rows'] = data.count rescue 0
    
    output
  end
  
  def formated_output_tables(name, status, message, data, elapsed_time)
    output = {'name' => name, 'columns' => [], 'rows' => 0, 'elapsed_time' => 0.0, 'data' => [], 'status' => '', 'message' => ''}

    output['elapsed_time'] = spent_time_tag(elapsed_time)
    output['status'] = status
    output['message'] = message
    output['data'] = data
    output['columns'] = ['table_name', 'column_name', 'data_type']
    output['types'] = ['string', 'string', 'string']
    output['rows'] = data.count
    
    output
  end
  
  def filter_source_attributes(source_attributes)
    case source_attributes['adapter']
    when 'mysql2'
      excluded = ['encoding', 'pool']
      source_attributes.except(*excluded)
    when 'postgresql'
      source_attributes.except(*excluded)
    when 'sqlite3'
      excluded = ['username', 'host', 'port', 'password', 'encoding']
      source_attributes.except(*excluded)
    end
  end
end
