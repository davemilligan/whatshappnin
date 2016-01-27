##
# Class RegistrationStoriesTest implements the integration testing
# of the welcome controller.
#
##
require "#{File.dirname(__FILE__)}/../test_helper"

class RegistrationStoriesTest < ActionController::IntegrationTest
  fixtures 'patrons'


  ##
  # a patron comes to the welcome screen, selects the register option, 
  # registers valid details, gets redirected to the login screen via 
  # the notification screen, then logs in.
  def test_registering
    Patron.delete_all
    get 'welcome/index'
    assert_response :success
    assert_template 'index'
    get 'login/register'
    assert_response :success
    assert_template 'register'
    post_via_redirect 'login/register',
                      :patron => {
                          :username => "test_dave",
                          :email => "david@test_dave.com",
                          :email_confirmation => "david@test_dave.com"
                      }   
    assert_response :success
    post_via_redirect 'login/login',
                      { :username => 'david',
                        :password => 'secret '}
    assert_response :success
  end
  
  ##
  # a patron comes to the welcome screen, selects the register option, 
  # registers invalid details, gets flushed back to the register with
  # an error message.
  def test_registering_bad
    Patron.delete_all
    get 'welcome/index'
    assert_response :success
    assert_template 'index'
    get 'welcome/register'
    assert_response :success
    assert_template 'register'
    post 'welcome/register',
                      :patron => {
                          :username => "test_dave",
                          :email => "davd@test_dave.com",
                          :email_confirmation => "david@test_dave.com"
                      }   
    assert_template 'register'
  end
end
