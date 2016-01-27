require File.dirname(__FILE__) + '/../test_helper'
require 'resources_controller'

# Re-raise errors caught by the controller.
class ResourcesController; def rescue_action(e) raise e end; end

class ResourcesControllerTest < Test::Unit::TestCase
  fixtures :resources
  def setup
    @controller = ResourcesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @first_id = resources(:dud)
  end

  def test_new
    get :new
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:resource)
  end
  
  def test_create_get
    get :create
    assert_redirected_to :controller => 'admin', :action => 'index'
  end
  
  def test_create_good
    num_resources = Resource.count
    post :create, :resource => {:name => 'daft_name', :value => 'daft_value'}
    assert_redirected_to :controller => 'admin', :action => 'show_resources'
    assert_equal num_resources + 1, Resource.count
  end

  def test_create_bad
    num_resources = Resource.count
    post :create
    assert_template 'new'
    assert_equal num_resources, Resource.count
  end

  def test_edit
    get :edit, :id => @first_id
    assert_response :success
    assert_template 'edit'
    assert_not_nil assigns(:r)
    assert assigns(:r).valid?
  end
  
end
