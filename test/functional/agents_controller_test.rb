##
# Class AgentsControllerTest handles the functional testing
# of the AgentsController Object
#
##
require File.dirname(__FILE__) + '/../test_helper'
require 'agents_controller'

# Re-raise errors caught by the controller.
class AgentsController; def rescue_action(e) raise e end; end

class AgentsControllerTest < Test::Unit::TestCase
  fixtures :users
  fixtures :venues
  fixtures :events

  def setup
    @controller = AgentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = users(:dave).id
  end

  def test_get_index
    dave = users(:dave)
    get :index, {}, { :user_id => 1 }
    assert assigns(@venues)
    assert assigns(@events)
    assert assigns(@completed_events)
    assert_response :success    
  end

  def test_get_index_no_agent
    get :index
    assert_redirected_to :controller => 'welcome', :action => 'signin'
  end
  
  def test_edit_venue
    bunker = venues(:bunker)
    get :edit_venue,{:id => bunker.id }, {:user_id => 1 }
    assert_response :success 
  end 
  
  def test_get_create_venue
    get :create_venue,{}, {:user_id => 1 }
    assert_template 'create_venue'
  end 

  def test_post_create_venue
    bunker = venues(:bunker)
    post :create_venue,{:venue => {:title => bunker.title,
                                   :street => bunker.street,
                                   :city => bunker.city,
                                   :county => bunker.county,
                                   :country => bunker.country,
                                   :postcode => bunker.postcode,
                                   :v_type => bunker.v_type,
                                   :description => bunker.description,
                                   :user_id => bunker.user_id }},
                        {:user_id => 1 }
    assert_redirected_to :action => 'index'
  end 

  def test_post_update_venue 
    bunker = venues(:bunker)
    post :update_venue,{:venue => {:id => bunker.id,
                                   :title => bunker.title,
                                   :street => bunker.street,
                                   :city => bunker.city,
                                   :county => bunker.county,
                                   :country => bunker.country,
                                   :postcode => bunker.postcode,
                                   :v_type => bunker.v_type,
                                   :description => bunker.description,
                                   :user_id => bunker.user_id }},
                        {:user_id => 1 }
    assert_redirected_to :action => 'index'
  end

  def test_get_update_venue 
    bunker = venues(:bunker)
    get :update_venue,{:venue => {:id => bunker.id}}, {:user_id => 1 }
    assert_redirected_to :controller => 'agents'
  end
  
  def test_get_upload_image
    dave = users(:dave)
    bunker = venues(:bunker)
    get :upload_image, {:id => bunker.id },{:user_id => dave.id }
    assert assigns(@venue)
    assert assigns(@picture)
    assert assigns(@picture_available)
    assert_template 'upload_image'
  end
  
  def test_get_create_event
    dave = users(:dave)
    bunker = venues(:bunker)
    get :create_event, {:id => bunker.id },{:user_id => dave.id }
    assert assigns(@venue)
    assert assigns(@event)
    assert_template 'create_event'
  end

  def test_post_create_event
    dave = users(:dave)
    bunker = venues(:bunker)
    grad = events(:gradball)
    post :create_event, {:id => bunker.id, 
                         :event => {
                             :postcode => grad.postcode,
                             :title => grad.title,
                             :county => grad.county,
                             :country => grad.country,
                             :venue_id => grad.venue_id,
                             :id => grad.id,
                             :city => grad.city,
                             :ends => grad.ends,
                             :description => grad.description,
                             :e_type => grad.e_type,
                             :begins => grad.begins,
                             :user_id => grad.user_id } 
                         },
                        {:user_id => dave.id }
    assert assigns(@venue)
    assert assigns(@event)
    assert_response :success
  end

  def test_post_create_event_bad_details
    dave = users(:dave)
    bunker = venues(:bunker)
    grad = events(:gradball)
    post :create_event, {:id => bunker.id, 
                         :event => {
                             :postcode => grad.postcode,
                             :title => nil,
                             :county => grad.county,
                             :country => grad.country,
                             :venue_id => grad.venue_id,
                             :id => grad.id,
                             :city => grad.city,
                             :ends => grad.ends,
                             :description => grad.description,
                             :e_type => grad.e_type,
                             :begins => grad.begins,
                             :user_id => grad.user_id } 
                         },
                        {:user_id => dave.id }
    assert assigns(@venue)
    assert assigns(@event)
    assert_template 'create_event'
  end

  def test_get_update_event
    dave = users(:dave)
    grad = events(:gradball)
    get :update_event, {:id => grad.id },{:user_id => dave.id }
    assert assigns(@venue)
    assert assigns(@event)
    assert_template 'update_event'
  end

  def test_post_update_event
    dave = users(:dave)
    grad = events(:gradball)
    post :update_event, {:id => grad.id, 
                         :event => {
                             :postcode => grad.postcode,
                             :title => grad.title,
                             :county => grad.county,
                             :country => grad.country,
                             :venue_id => grad.venue_id,
                             :id => grad.id,
                             :city => grad.city,
                             :ends => grad.ends,
                             :description => grad.description,
                             :e_type => grad.e_type,
                             :begins => grad.begins,
                             :user_id => grad.user_id } 
                         },
                        {:user_id => dave.id }
    assert assigns(@venue)
    assert assigns(@event)
    assert_response :success
  end

  def test_get_destroy_event
    dave = users(:dave)
    grad = events(:gradball)
    get :destroy_event, {:id => grad.id }, {:user_id => dave.id }
    assert_nil @event
    assert_redirected_to :controller => 'agents'       
  end
  
  def test_post_destroy_event
    dave = users(:dave)
    grad = events(:gradball)
    post :destroy_event, {:id => grad.id }, {:user_id => dave.id }
    assert_nil @event
    assert_redirected_to :action => 'index'       
  end

  def test_get_destroy_venue
    dave = users(:dave)
    bunker = venues(:bunker)
    get :destroy_venue, {:id => bunker.id }, {:user_id => dave.id }
    assert_nil @venue
    assert_redirected_to :controller => 'agents'       
  end
  
  def test_post_destroy_venue
    dave = users(:dave)
    bunker = venues(:bunker)
    post :destroy_venue, {:id => bunker.id }, {:user_id => dave.id }
    assert_nil @venue
    assert_redirected_to :action => 'index'       
  end
end 
