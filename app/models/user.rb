# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  password   :string
#  salt       :string
#  role_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  belongs_to :role
end
