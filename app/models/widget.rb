# == Schema Information
#
# Table name: widgets
#
#  id          :integer          not null, primary key
#  name        :string
#  sys         :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Widget < ActiveRecord::Base
  REFRESH_TIME = ['NO', 1, 2, 5, 10, 30, 60]
  LIMITS = ['NO', 1, 5, 10, 25, 50, 100, 200, 500, 1000, 5000, 10000, 50000, 100000]
  
  module Type
    TABLE = '1'
    LINE = '2'
    COLUMN = '3'
    PIE = '4'
  end
end
