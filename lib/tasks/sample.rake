namespace :sample do
  ROWS_COUNT = 100_000

  desc 'Load sample data'
  task :load => :environment do
    generate_data
    generate_sources
    generate_reports
    load_data
  end

  def generate_data
    cisco
  end

  def generate_sources
    unless Source.exists?(name: 'Intelli Cisco Sample Data Source')
      Source.create(name: 'Intelli Cisco Sample Data Source', destination: 'file', path: File.join(Rails.root, 'db', 'cisco.sample'))
    end
  end

  def generate_reports
    unless Report.exists?(name: 'Intelli Cisco Sample Data Report')
      source = Source.where(name: 'Intelli Cisco Sample Data Source').first
      Report.create(name: 'Intelli Cisco Sample Data Report', source_id: source.id, regular_expression: 'NETFLOW:\s+(\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}\.\d{3})\s+(\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}\.\d{3})\s+(\d+\.\d+)\s+([A-Z]+)\s+(\d{,3}\.\d{,3}\.\d{,3}\.\d{,3}):(\d+)\s+->\s+(\d{,3}\.\d{,3}\.\d{,3}\.\d{,3}):(\d+).*?\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(.+?)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)', observations_type: 0)
    end
  end

  def load_data
    samples = Report.where(['name LIKE ?', 'Intelli % Sample Data Report'])
    for sample in samples
      observations = sample.execute
      sample.store(observations)
    end
  end

  private
  def cisco
    now = Time.now - 7.days

    f = File.open(File.join(Rails.root, 'db', 'cisco.sample'), 'w+')
    shifted = 0
    ROWS_COUNT.times do |i|
      record = []
      record << 'NETFLOW:'
      started_at = now + shifted.seconds
      record << started_at.strftime('%Y-%m-%d %H:%M:%S.%3N')
      finished_at = now + shifted.seconds + rand(3)
      record << finished_at.strftime('%Y-%m-%d %H:%M:%S.%3N')
      record << '%.3f' % (finished_at - started_at)
      record << ['TCP', 'UDP', 'ICMP'][rand(3)]
      record << Array.new(4) {rand(256)}.join('.') + ':' + rand(65536).to_s
      record << '->'
      record << Array.new(4) {rand(256)}.join('.') + ':' + rand(65536).to_s
      record << 0 << 0 << 4 << rand(65536) << '......' << 0 << 0 << 0 << 0 << 0 << 0 << 1

      shifted += rand(10)
      f.puts record.join(' ')
    end
    f.close
  end
end
