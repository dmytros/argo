# == Schema Information
#
# Table name: schedulers
#
#  id           :integer          not null, primary key
#  report_id    :integer
#  start_at     :datetime
#  end_at       :datetime
#  last_run_at  :datetime
#  repeat_every :integer
#  repeat_type  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Scheduler < ActiveRecord::Base
  validates :report_id, :repeat_every, :repeat_type, :start_at, presence: true
  validates :report_id, uniqueness: true
  
  module RepeatType
    HOURLY = 0
    DAILY = 1
    WEEKLY = 2
    MONTHLY = 3
    
    ALL = [['Hour', HOURLY], ['Day', DAILY], ['Week', WEEKLY], ['Month', MONTHLY]]
  end
  
  belongs_to :report
  
  def self.call_was_for(scheduler_id)
    source = find(scheduler_id)
    source.update_attributes(last_run_at: Time.now)
  end
  
  def should_run?
    return true if last_run_at.nil?
    return false if start_at > Time.now
    
    unless end_at.nil?
      return false if end_at < Time.now
    end
    
    case repeat_type
    when RepeatType::HOURLY
      last_run_at + repeat_every.hours < Time.now
    when RepeatType::DAILY
      last_run_at + repeat_every.days < Time.now
    when RepeatType::WEEKLY
      last_run_at + repeat_every.weeks < Time.now
    when RepeatType::MONTHLY
      last_run_at + repeat_every.months < Time.now
    end
  end
  
  def period
    "#{repeat_every} #{Scheduler::RepeatType::ALL.map {|item| item[0]}[repeat_type]}"
  end
end
