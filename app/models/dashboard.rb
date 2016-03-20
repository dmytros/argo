# == Schema Information
#
# Table name: dashboards
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Dashboard < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :dashboard_widgets
end
