# == Schema Information
#
# Table name: sources
#
#  id          :integer          not null, primary key
#  name        :string
#  username    :string
#  host        :string
#  port        :string
#  database    :string
#  password    :string
#  adapter     :string
#  encoding    :string
#  pool        :string
#  destination :string           default("database")
#  path        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class SourceTest < ActiveSupport::TestCase
  test "validations on save empty source" do
    source = Source.new

    # should not be saved empty source
    assert_not source.save
    
    # should be 6 errors
    assert_equal 6, source.errors.messages.size
    
    # should be 6 errors for next fields
    assert_equal [:name, :host, :username, :port, :database, :adapter], source.errors.messages.keys
    
    # should be next errors for next fields
    assert_equal ["can't be blank"], source.errors.messages[:name]
    assert_equal ["can't be blank"], source.errors.messages[:host]
    assert_equal ["can't be blank"], source.errors.messages[:username]
    assert_equal ["can't be blank", "is not a number"], source.errors.messages[:port]
    assert_equal ["can't be blank"], source.errors.messages[:database]
    assert_equal ["can't be blank", "is not included in the list"], source.errors.messages[:adapter]
    
    assert true
  end

  test "validations on save source to name field" do
    source = Source.new

    # should not be saved empty source
    assert_not source.save
    
    # should be next errors for next fields
    assert_equal ["can't be blank"], source.errors.messages[:name]
    
    # set to empty
    source.name = ""
    assert_not source.save
    assert_equal ["can't be blank"], source.errors.messages[:name]
    
    # set to nil
    source.name = nil
    assert_not source.save
    assert_equal ["can't be blank"], source.errors.messages[:name]
    
    # set to int
    source.name = 123
    assert_not source.save
    assert_nil source.errors.messages[:name]
    
    # set to special chars
    source.name = '~!@#{$%^&*()_+|}'
    assert_not source.save
    assert_nil source.errors.messages[:name]
    
    # set to more than 255 symbols
    source.name = '0123456789' * 26
    assert_not source.save
    assert_nil source.errors.messages[:name]
    
    # set to exists name
    source.name = 'Test #0'
    assert_not source.save
    assert_equal ["has already been taken"], source.errors.messages[:name]
    
    assert true
  end
end
