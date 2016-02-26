# == Schema Information
#
# Table name: reports
#
#  id                 :integer          not null, primary key
#  name               :string
#  sql                :text
#  regular_expression :text
#  source_id          :integer
#  observations_type  :integer          default(0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
