##
# Class LoginStoriesTest implements the integration testing
# of the welcome controller.
#
##
require "#{File.dirname(__FILE__)}/../test_helper"

class LoginStoriesTest < ActionController::IntegrationTest
  fixtures 'users'


  ##
  # a patron comes to the welcome screen, selects the login option, 
  # enters valid details, gets redirected to the welcome screen.
  def test_login 
    dave = users(:dave)
    get 'welcome/index'
    assert_response :success
    get 'welcome/login'
    assert_response :success
    post_via_redirect 'welcome/login',
                      { :username => dave.username,
                        :password => 'secret'}
    assert_response :success
    assert_equal session[:user_id], dave.id
    assert_template 'index'
  end
 
  ##
  # a patron comes to the welcome screen, selects the login option, 
  # enters invalid details, gets flushed back to the login screen. 
  def test_login_bad_password 
    dave = users(:dave)
    get 'welcome/index'
    assert_response :success
    get 'welcome/login'
    assert_response :success
    post_via_redirect 'welcome/login',
                      { :username => dave.username,
                        :password => 'not_secret'}
    assert_response :success
    assert_equal session[:user_id], nil
    assert_template 'login'
  end
  
  ##
  # a patron comes to the welcome screen, selects the login option, 
  # enters invalid details, gets flushed back to the login screen.   
  def test_login_bad_username 
    dave = users(:dave)
    get 'welcome/index'
    assert_response :success
    get 'welcome/login'
    assert_response :success
    post_via_redirect 'welcome/login',
                      { :username => 'bad_username',
                        :password => 'not_secret'}
    assert_response :success
    assert_equal session[:user_id], nil
    assert_template 'login'
  end
  
  
  ##
  # a patron comes to the welcome screen, selects the login option, 
  # forgets their username, requests a reminder and is redirected
  # back to the login via a confirmation screen.   
  def test_forgot_username 
    dave = users(:dave)
    get 'welcome/index'
    assert_response :success
    get 'welcome/login'
    get 'welcome/forgot_username'
    assert_response :success
    post_via_redirect 'welcome/forgot_username',
                      { :email => dave.email }
    assert_response :success
    assert_template 'notify'
  end
  
  ##
  # a patron comes to the welcome screen, selects the login option, 
  # forgets their password, requests a reset and is redirected
  # back to the login via a confirmation screen.   
  def test_forgot_password 
    dave = users(:dave)
    get 'welcome/index'
    assert_response :success
    get 'welcome/login'
    get 'welcome/forgot_password'
    assert_response :success
    post_via_redirect 'welcome/forgot_password',
                      { :username => dave.username }
    assert_response :success
    assert_template 'notify'
  end
  
  ##
  # a patron comes to the welcome screen, selects the login option, 
  # forgets their password, requests a reset but supplies an incorrect
  # username, they are flushed back to the originating screen.   
  def test_forgot_password_bad_username 
    dave = users(:dave)
    get 'welcome/index'
    assert_response :success
    get 'welcome/login'
    get 'welcome/forgot_password'
    assert_response :success
    post_via_redirect 'welcome/forgot_password',
                      { :username => "bad_username" }
    assert_response :success
    assert_template 'forgot_password'
  end
  
  ##
  # a patron comes to the welcome screen, selects the login option, 
  # forgets their username, requests a reminder but supplies an incorrect
  # email, they are flushed back to the originating screen.   
  def test_forgot_username_bad_email 
    dave = users(:dave)
    get 'welcome/index'
    assert_response :success
    get 'welcome/login'
    get 'welcome/forgot_username'
    assert_response :success
    post_via_redirect 'welcome/forgot_username',
                      { :email => "dud_email" }
    assert_response :success
    assert_template 'forgot_username'
  end
end
