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

class User < ActiveRecord::Base
  belongs_to :role

  before_save :set_default_role

#  attr_accessor :password_confirmation

  validates :name, presence: true, uniqueness: true
  validates :password, presence: true
#  validates :password, confirmation: true
#  validates :password_confirmation, presence: true

  def super?
    id === 1
  end

  def active?
    is_active
  end

  def activate
    self.is_active = true
    self.save
  end

  def deactivate
    self.is_active = false
    self.save
  end

  def self.authenticate(name, password)
    user = self.where(name: name).first
    if user
      user = nil if user.hashed_password != encrypted_password(password, user.salt) || !user.active?
    end
    user
  end

  def password=(pwd)
    self.salt = self.object_id.to_s + rand.to_s
    self.hashed_password = User.encrypted_password(pwd, self.salt)
  end

  def password
    self.hashed_password
  end

#  def password_confirmation
#    self.password_confirmation
#  end

  private
  def self.encrypted_password(password, salt)
    Digest::SHA1.hexdigest(password + 'argos' + salt)
  end

  def set_default_role
    self.role = Role.user if self.role.nil?
  end
end
