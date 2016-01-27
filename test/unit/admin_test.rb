##
# Class Admin test carries out Unit Testing of the
# Admin helper class.
#
##

require File.dirname(__FILE__) + '/../test_helper'

class AdminTest < Test::Unit::TestCase
  fixtures :users
  
  def test_suspend
    dave = users(:dave)
    Admin.suspend(dave.id)
    dave = User.find(dave.id) 
    assert_equal true, dave.suspended
  end

   def test_retore
    dave = users(:dave)
    Admin.suspend(dave.id)
    dave = User.find(dave.id) 
    assert_equal true, dave.suspended
    Admin.restore(dave.id)
    dave = User.find(dave.id) 
    assert_equal false, dave.suspended
  end 
  
  def test_to_patron
    dave = users(:dave)
    Admin.to_patron(dave.id)
    dave = User.find(dave.id) 
    assert_equal 0, dave.level
  end 
  
  def test_to_agent
    dave = users(:dave)
    Admin.to_agent(dave.id)
    dave = User.find(dave.id) 
    assert_equal 1, dave.level
  end  

  def test_to_admin
    dave = users(:dave)
    Admin.to_admin(dave.id)
    dave = User.find(dave.id) 
    assert_equal 2, dave.level
  end
end
