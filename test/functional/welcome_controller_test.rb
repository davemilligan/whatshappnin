##
# Class WelcomeControllerTest provides functional testing
# for the WelcomeController Object.
##
require File.dirname(__FILE__) + '/../test_helper'
require 'welcome_controller'

# Re-raise errors caught by the controller.
class WelcomeController; def rescue_action(e) raise e end; end

class WelcomeControllerTest < Test::Unit::TestCase
  fixtures :resources
  fixtures :users
  def setup
    @controller = WelcomeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_post_signin_no_details
    post :signin
    assert_response :success    
  end
  
  def test_post_signin_good_details
    dave = users(:dave)
    post :signin, :username => dave.username, :password => 'secret'
    assert_redirected_to :controller => 'welcome', :action => 'index'
    assert_equal dave.id, session[:user_id]
  end
  
  def test_post_signin_bad_details
    dave = users(:dave)
    post :signin, :username => dave.username, :password => 'bad_password'
    assert_template "signin"
  end
  
  def test_get_signin
    dave = users(:dave)
    get :signin, :username => dave.username, :password => 'secret'
    assert_template "signin"    
  end
  
  def test_signout_with_user
    dave = users(:dave)
    post :signin, :username => dave.username, :password => 'secret'
    get :signout
    assert_redirected_to :controller => 'welcome', :action => 'index'
  end  
    
  def test_signout_without_user
    get :signout
    assert_nil session[:user_id]
    assert_redirected_to :controller => 'welcome', :action => 'index'
  end

  def test_get_register
    get :register
    assert !assigns(:user).valid? 
    assert_response :success
  end
  
  def test_post_register_no_param
    post :register
    assert !assigns(:user).valid? 
    assert_template 'register' 
  end
  
  def test_post_register_missing_param
    post :register, :username => 'dave'
    assert !assigns(:user).valid? 
    assert_template 'register' 
  end
  
  def test_post_register_good
    post :register, :user => { :username => 'joseph', 
                                 :email => 'jgjhgj' }
    assert assigns(session[:user_id])
    assert_response :success    
  end
 
  def test_forgot_password_bad_username
    post :forgot_password, :username => 'xxxxxxx'
    assert_template "forgot_password"
  end
  
  def test_forgot_password_good_username
    post :forgot_password, :username => 'dave'
    assert_redirected_to :action => "notify"
  end
   
  def test_forgot_username_bad_email
    post :forgot_username, :email => 'xxxxxxx'
    assert_template "forgot_username"
  end
  
  def test_forgot_username_good_email
    dave = users(:dave)
    post :forgot_username, :username => dave.email
    assert_template "forgot_username"
  end
  
  def test_notify
    get :notify
    assert_template "notify"
  end
end
