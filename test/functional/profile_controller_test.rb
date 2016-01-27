require File.dirname(__FILE__) + '/../test_helper'
require 'profile_controller'

# Re-raise errors caught by the controller.
class ProfileController; def rescue_action(e) raise e end; end

class ProfileControllerTest < Test::Unit::TestCase
  def setup
    @controller = ProfileController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index_not_signed_in
    get :index
    assert_redirected_to :controller => 'login', :action => 'login'
  end
 
  def test_index_signed_in
    get :index, {}, { :user_id => 1 }
    assert_template 'index'
  end
  
  def test_changed_passwords_mismatched
    post :change_password, { :old_p => 'secret', 
                            :new_p => 'good', 
                            :new_p_conf => 'bad' },  
                          { :user_id => 1 }
    assert_redirected_to :action => 'login'
  end  
  
  def test_changed_passwords_matched
    post :change_password, { :old_p => 'secret', 
                            :new_p => 'good', 
                            :new_p_conf => 'good' },  
                           { :user_id => 1 }
    assert_redirected_to :action => 'changed'
  end 
  
  def test_changed_passwords_wrong_format_numeric
    post :change_password, { :old_p => 'secret', 
                            :new_p => '123456', 
                            :new_p_conf => '123456' },  
                           { :user_id => 1 }
    assert_equal flash[:password], 'test_value'
  end 
  
  def test_changed_passwords_wrong_format_non_alpha
    post :change_password, { :old_p => 'secret', 
                            :new_p => '_sherriff', 
                            :new_p_conf => '_sherriff' },  
                           { :user_id => 1 }
    assert_equal flash[:password], 'test_value'
    assert_redirected_to :action => 'login'
  end 

  def test_changed_password_invalid_password
    post :change_password, { :old_p => 'bad', 
                            :new_p => 'good', 
                            :new_p_conf => 'good' },  
                           { :user_id => 1 }
    assert_redirected_to :action => 'index'
  end
  
  def test_changed_password_invalid_user_id
    post :change_password, { :old_p => 'bad', 
                            :new_p => 'good', 
                            :new_p_conf => 'good' },  
                          { :user_id => 6 }
    assert_redirected_to :controller => 'login', :action => 'login'
  end  
 
  def test_update_get
    get :update, {}, { :user_id => 1 }
    assert_redirected_to :controller => 'welcome', 
                         :action => 'index'
  end
  
  def test_update_profile_good
    dave = patrons(:dave)
    assert_equal dave.fname, nil
    assert_equal dave.lname, nil
    assert_equal dave.address, nil
    assert_equal dave.postcode, nil
    post :update, { :id => dave.id,
                    :patron => {:fname => 'dave',
                                :lname => 'milligan',
                                :email => 'dave@whatshappnin.info',                                
                                :address => 'dadadaddadad',
                                :postcode => 'qqqqqq'} },
                  { :user_id => dave.id }
    assert_equal flash[:heading], 'test_value'
    assert_equal flash[:message], 'test_value'
    assert_redirected_to :action => 'changed'                
  end
  
  def test_update_profile_not_logged_in
    dave = patrons(:dave)
    post :update, { :patron => {:fname => 'dave',
                                :lname => 'milligan',
                                :address => 'dadadaddadad',
                                :postcode => 'qqqqqq'} }
    assert_equal flash[:notice], 'test_value'
    assert_redirected_to :controller => 'login', :action => 'login'                
  end  
end
