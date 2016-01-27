require File.dirname(__FILE__) + '/../test_helper'
require 'forum_controller'

# Re-raise errors caught by the controller.
class ForumController; def rescue_action(e) raise e end; end

class ForumControllerTest < Test::Unit::TestCase
  fixtures :users
  fixtures :venues
  fixtures :events
  fixtures :comments
   
  def setup
    @controller = ForumController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_get_post_comment
    dave = users(:dave)
    get :post_comment, {}, { :user_id => dave.id }    
  end

  def test_get_post_reply
    dave = users(:dave)
    get :post_reply, {}, { :user_id => dave.id }       
  end

  def test_get_destroy_comment
    dave = users(:dave)
    get :destroy_comment, {}, { :user_id => dave.id }     
  end

  def test_get_destroy__reply
    dave = users(:dave)
    get :destroy_reply, {}, { :user_id => dave.id }
  end

end
