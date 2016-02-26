# == Schema Information
#
# Table name: component_casts
#
#  id           :integer          not null, primary key
#  component_id :integer
#  cast_id      :integer
#  position     :string           default("in"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class ComponentCastTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
