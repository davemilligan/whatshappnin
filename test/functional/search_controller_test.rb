##
# Class SearchControllerTest handles the functional 
# testing of the SearchController Object
##
require File.dirname(__FILE__) + '/../test_helper'
require 'search_controller'

# Re-raise errors caught by the controller.
class SearchController; def rescue_action(e) raise e end; end

  
class SearchControllerTest < Test::Unit::TestCase
  fixtures :users
  fixtures :venues
  fixtures :events
  fixtures :countries
  def setup
    @controller = SearchController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert assigns(:country)
    assert_template 'index'
  end

  def test_post_index
    post :index
    assert assigns(:country)
    assert_template 'index'
  end

  def test_country_category
    portugal = countries(:Portugal)
    get :country_category, {:country => portugal.printable_name }
    assert assigns(:category)
    assert assigns(:country)
    assert_template 'country_category'
  end

  def test_post_country_category
    portugal = countries(:Portugal)
    post :country_category, {:country => portugal.printable_name }
    assert assigns(:category)
    assert assigns(:country)
    assert_template 'country_category'
  end
  
  def test_country_category_id
    portugal = countries(:Portugal)
    get :country_category, {:country => portugal.printable_name,
                            :id => 'bar' }
    assert assigns(:category)
    assert assigns(:country)
    assert_template 'country_category'
  end
  
  def test_post_country_category_id
    portugal = countries(:Portugal)
    post :country_category, {:country => portugal.printable_name,
                            :id => 'bar' }
    assert assigns(:category)
    assert assigns(:country)
    assert_template 'country_category'
  end 
   
  def test_city_category
    france = countries(:France)
    get :city_category, { :id => 'Paris', 
                          :country => france.printable_name }
    assert assigns(:category)
    assert assigns(:country)
    assert assigns(:city) 
    assert_template 'city_category'  
  end 
 
  def test_post_city_category
    france = countries(:France)
    post :city_category, { :id => 'Paris', 
                          :country => france.printable_name }
    assert assigns(:category)
    assert assigns(:country)
    assert assigns(:city) 
    assert_template 'city_category'  
  end 
  
  def test_city_category_category
    france = countries(:France)
    get :city_category, { :id => 'Paris', 
                          :country => france.printable_name,
                          :category => 'bar' }
    assert assigns(:category)
    assert assigns(:country)
    assert assigns(:city) 
    assert_template 'city_category'  
  end    

  def test_post_city_category_category
    france = countries(:France)
    post :city_category, { :id => 'Paris', 
                          :country => france.printable_name,
                          :category => 'bar' }
    assert assigns(:category)
    assert assigns(:country)
    assert assigns(:city) 
    assert_template 'city_category'  
  end 
  
  def test_venue
    bunker = venues(:bunker)
    get :venue, { :id => bunker.id }
    assert assigns(:comments)
    assert assigns(:replies)
    assert_template 'venue'  
  end

  def test_post_venue
    bunker = venues(:bunker)
    post :venue, { :id => bunker.id }
    assert assigns(:comments)
    assert assigns(:replies)
    assert_template 'venue'  
  end
  
  def test_free_search_no_town
    france = countries(:France)
    get :free_search, { :search => {:country => france.printable_name,
                                    :city => '' }}
    assert assigns(:country)
    assert_template 'country_category'
  end

  def test_post_free_search_no_town
    france = countries(:France)
    post :free_search, { :search => {:country => france.printable_name,
                                    :city => '' }}
    assert assigns(:country)
    assert_template 'country_category'
  end
  
  def test_free_search_town
    france = countries(:France)
    get :free_search, { :search => {:country => france.printable_name,
                                    :city => 'paris' }}
    assert assigns(:country)
    assert assigns(:city)
    assert_template 'city_category'
  end

  def test_post_free_search_town
    france = countries(:France)
    post :free_search, { :search => {:country => france.printable_name,
                                    :city => 'paris' }}
    assert assigns(:country)
    assert assigns(:city)
    assert_template 'city_category'
  end
end
