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

class ComponentCast < ActiveRecord::Base
  belongs_to :component
  belongs_to :cast
  
  scope :inputs, -> {
    where(position: 'in')
  }
  
  scope :outputs, -> {
    where(position: 'out')
  }
end
