# == Schema Information
#
# Table name: execute_details
#
#  id              :integer          not null, primary key
#  name            :string
#  executable_id   :integer
#  executable_type :string
#  rows_count      :integer
#  is_success      :boolean
#  spent_time      :float
#  message         :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class ExecuteDetailTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
