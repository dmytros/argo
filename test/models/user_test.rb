# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string
#  hashed_password :string
#  salt            :string
#  role_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  is_active       :boolean          default(FALSE)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
