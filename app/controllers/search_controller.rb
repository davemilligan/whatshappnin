##
# The Search Controller handles all requests for information and may be based 
# on country, category, city, venue and event.  
# The functionality of the Search Controller will be available to all users.
# 
class SearchController < ApplicationController
  layout 'whatshappnin'
  
  ##
  #  the default action renders the initial search screen
  def index  
    @country = "United Kingdom";
  end
  
  ##
  #  Renders the a display with an ActionRecord Object
  #  representing a country chosen.
  #  
  def country_category
    if !params[:id]
      @category = 'bar'
    else
      @category = params[:id]
    end
    @country = Country.find_by_printable_name(params[:country])
  end

  ##
  #  Renders the a display with a refernece to
  #  a city, country, and a list of available categories.
  #  
  def city_category
    @city = params[:id]
    if !params[:category]
      @category = 'bar'
    else
      @category = params[:category]
    end
    @country = Country.find_by_printable_name(params[:country])
  end

  ##
  #  Renders the a display with ActionRecord Object
  #  representing a chosen venue and all associated comments.
  #  
  def venue
    @venue = Venue.find(params[:id])
    @comments = get_comments("venue", @venue.id)
    @replies = []
    @comments.each do|c|      
      Comment.find_all_by_reply(c.id).each do|r|
        @replies << r
      end
    end
  end
 
  ##
  #  Renders the a display with ActionRecord Object
  #  representing a chosen event and all associated comments.
  #   
  def event
    @event = params[:id]
    @comments = get_comments("event", params[:id])
    @replies = []
    @comments.each do|c|      
      Comment.find_all_by_reply(c.id).each do|r|
        @replies << r
      end
    end    
  end
  
  ##
  #  Handles a free search from the default search screen, and decides if a 
  #  search by country or city is more appropriate.
  #   
  def free_search
    @city = params[:search][:city]
    @category = 'bar'
    @country = Country.find_by_printable_name(params[:search][:country])
    if @city == ""
      render :action => 'country_category'
    else
      render :action => 'city_category'
    end
  end
  
  ##
  #  Returns an image related to a venue id.
  #   
  def get_venue_picture
    @picture = Picture.find_by_owner_id(params[:id])
    if @picture
      send_data(@picture.data,
              :filename => @picture.name,
              :type => @picture.content_type,
              :disposition => "inline")
    end
  end  
  

end
