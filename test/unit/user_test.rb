##
# Class UserTest carries out the Unit Testing of the 
# User data model.
##
require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users

  def test_invalid_with_empty_attributes
    user = User.new
    assert !user.valid?
    assert user.errors.invalid?(:username)  
  end
  
  def test_duplicate_username
    good_dave = users(:dave)
    dud_dave = users(:david)
    dud_dave.username = "dave"
    assert !dud_dave.save   
  end
  
  def test_missing_email
    dud_dave = users(:dave)
    dud_dave.email = ""
    assert !dud_dave.save   
  end   

  def test_bad_username
    dud_dave = User.find(users(:dave).id)
    dud_dave.username = " 55555"
    assert !dud_dave.save  
  end 
end
