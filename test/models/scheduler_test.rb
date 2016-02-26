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

require 'test_helper'

class SchedulerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
