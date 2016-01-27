##
# Class AdminControllerTest implements the functional
# testing of the AdminController Object.
#
#
##
require File.dirname(__FILE__) + '/../test_helper'
require 'admin_controller'

# Re-raise errors caught by the controller.
class AdminController; def rescue_action(e) raise e end; end

class AdminControllerTest < Test::Unit::TestCase
  fixtures :users
  fixtures :venues
  fixtures :events
  fixtures :resources
  fixtures :upgrade_requests

  def setup
    @controller = AdminController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new    
  end
  
  def test_index
    dave = users(:dave)
    get :index, {}, { :user_id => dave.id }
    assert_redirected_to :action => 'show_resources'
  end

  def test_post_index
    dave = users(:dave)
    post :index, {}, { :user_id => dave.id }
    assert_redirected_to :action => 'show_resources'
  end

  def test_index_no_admin
    get :index
    assert_redirected_to :controller => 'welcome', :action => 'signin'
  end

  def test_post_index_no_admin
    post :index
    assert_redirected_to :controller => 'welcome', :action => 'signin'
  end
  
  def test_suspend_admin
    dave = users(:dave)
    get :suspend_admin, {:id => dave.id }, { :user_id => dave.id }
    assert_redirected_to :action => 'show_admins'
  end
  
  def test_restore_admin
    dave = users(:dave)
    get :restore_admin, {:id => dave.id }, { :user_id => dave.id }
    assert_redirected_to :action => 'show_admins'
  end

  def test_suspend_patron
    dave = users(:dave)
    get :suspend_patron, {:id => dave.id }, { :user_id => dave.id }
    assert_redirected_to :action => 'show_patrons'
  end

  def test_restore_patron
    dave = users(:dave)
    get :restore_patron, {:id => dave.id }, { :user_id => dave.id }
    assert_redirected_to :action => 'show_patrons'
  end
  
  def test_suspend_agent
    dave = users(:dave)
    get :suspend_agent, {:id => dave.id }, { :user_id => dave.id }
    assert_redirected_to :action => 'show_agents'
  end

  def test_restore_agent
    dave = users(:dave)
    get :restore_agent, {:id => dave.id }, { :user_id => dave.id }
    assert_redirected_to :action => 'show_agents'
  end
  
  def test_level_to_admin
    dave = users(:dave)
    get :level_to_admin, {:id => dave.id }, { :user_id => dave.id }
    assert_redirected_to :action => 'show_admins'
  end

  def test_level_to_agent
    dave = users(:dave)
    get :level_to_agent, {:id => dave.id }, { :user_id => dave.id }
    assert_redirected_to :action => 'show_agents'
  end 

  def test_level_to_patron
    dave = users(:dave)
    get :level_to_patron, {:id => dave.id }, { :user_id => dave.id }
    assert_redirected_to :action => 'show_patrons'
  end
  
  def test_upgrade_to_agent
    dave = users(:dave)
    get :upgrade_to_agent, {:id => dave.id }, { :user_id => dave.id }
    assert_redirected_to :action => 'show_upgrade_requests'  
  end
  
  
  def test_deny_upgrade
    dave = users(:dave)
    get :deny_upgrade, {:id => dave.id }, { :user_id => dave.id }
    assert_redirected_to :action => 'show_upgrade_requests'   
  end 
    
end