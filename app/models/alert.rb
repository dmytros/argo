# == Schema Information
#
# Table name: alerts
#
#  id         :integer          not null, primary key
#  name       :string
#  expression :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Alert < ActiveRecord::Base
end
