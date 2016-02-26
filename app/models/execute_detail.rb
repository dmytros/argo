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

class ExecuteDetail < ActiveRecord::Base
  belongs_to :executable, polymorphic: true
end
