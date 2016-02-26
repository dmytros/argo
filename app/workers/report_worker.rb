class ReportWorker
  include Sidekiq::Worker

  def perform(id)
    report = Report.find(id)
  end
end