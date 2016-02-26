# == Schema Information
#
# Table name: components
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Component < ActiveRecord::Base
  has_many :component_casts
  has_many :casts, through: :component_casts
  
  has_many :input_casts, -> { inputs }, class_name: 'ComponentCast'
  has_many :output_casts, -> { outputs }, class_name: 'ComponentCast'
end
