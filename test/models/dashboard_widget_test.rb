# == Schema Information
#
# Table name: dashboard_widgets
#
#  id           :integer          not null, primary key
#  dashboard_id :integer
#  widget_id    :integer
#  entity_id    :integer
#  entity_type  :string
#  refresh_time :integer
#  top          :integer
#  left         :integer
#  width        :integer
#  height       :integer
#  limits       :integer
#  x_axis       :string
#  y_axis       :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  y_axis_as    :string
#  x_axis_group :string
#

require 'test_helper'

class DashboardWidgetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
