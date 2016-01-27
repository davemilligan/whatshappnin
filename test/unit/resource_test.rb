##
# Class Resource tests carries out Unit Testing
# of the Resource data model.
##
require File.dirname(__FILE__) + '/../test_helper'

class ResourceTest < Test::Unit::TestCase

  def test_no_data
    res = Resource.new
    assert !res.valid?   
  end
  
  def test_no_name
    res = Resource.new
    res.value = 'Test'
    assert !res.valid? 
  end
  
  def test_no_value
    res = Resource.new
    res.name = 'Test'
    assert res.valid?   
  end
    
  def test_duplicate_name
    res = Resource.new
    res.name = 'app_title'
    res.value = 'dup_value1'
    res.save 
    res2 = Resource.new
    res2.name = 'app_title'
    res2.value = 'dup_value2'
    assert !res2.save
    assert_equal "variable already in db", res2.errors.on(:name) 
  end
end
