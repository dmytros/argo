class SchedulerWorker
  include Sidekiq::Worker

  def perform(report_id, scheduler_id)
    report = Report.find(report_id)
    observations = report.execute
    report.store(observations)
    Scheduler.call_was_for(scheduler_id)
  end
end