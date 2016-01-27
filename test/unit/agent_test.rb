##
# Class Agent Test carries out Unit Testing of the 
# Agent Helper Class.
##
require File.dirname(__FILE__) + '/../test_helper'

class AgentTest < Test::Unit::TestCase
  fixtures :users
  fixtures :events
  fixtures :venues
  fixtures :comments

  def test_destroy_event
    event = events(:gradball)
    Agent.destroy_event(event.id)
    assert_raise(ActiveRecord::RecordNotFound) {Event.find(event.id)}
  end
  
  def test_destroy_venue
    bunker = venues(:bunker)
    Agent.destroy_venue(bunker.id)
    assert_raise(ActiveRecord::RecordNotFound) {Event.find(bunker.id)}
  end 
  
  def test_destroy_venue_and_event_and_comments
    bunker = venues(:bunker)
    event = events(:gradball)
    comment = comments(:first)
    Agent.destroy_venue(bunker.id)
    assert_raise(ActiveRecord::RecordNotFound) {Event.find(event.id)}
    assert_raise(ActiveRecord::RecordNotFound) {Venue.find(bunker.id)}
    assert_raise(ActiveRecord::RecordNotFound) {Comment.find(comment.id)}
  end   
    
end
