class SystemWorker
  include Sidekiq::Worker

  def perform()
    schedulers = Scheduler.all
    
    schedulers.each do |scheduler|
      if scheduler.start_at <= Time.now && (Time.now <= (scheduler.end_at || Time.now))
        if scheduler.should_run?
          SchedulerWorker.perform_async(scheduler.report_id, scheduler.id)
        end
      end
    end
  end
end

Sidekiq::Cron::Job.create(name: 'System worker - every 1min', cron: '* * * * *', klass: 'SystemWorker')