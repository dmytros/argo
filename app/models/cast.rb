# == Schema Information
#
# Table name: casts
#
#  id         :integer          not null, primary key
#  name       :string
#  sys        :string
#  img_class  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Cast < ActiveRecord::Base
  has_many :component_casts
  has_many :components, through: :component_casts
end
