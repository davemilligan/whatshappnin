##
#    The Agent Controller manages all activities related to the management of 
#    venues and events related to an Agent.  
#    By accessing this controller an Agent can edit their profile, 
#    add new venues to manage events, 
#    upload images for publishing,
#    and mediate comments left by users.  
#    
#    The controller will include security measures to ensure that 
#    unauthorized users do not have access to functions that 
#    would enable them to change the state of the application 
#    where they are not entitled to do so. 
#    
#     
class AgentsController < ApplicationController
  helper 'search'
  layout 'whatshappnin' 
  
  ##
  #  first line of defence for unauthorized access
  #  
  before_filter :authorize_agent

  
  ##
  #   Renders the default screen for agents populated with all content 
  #   related to the agent.
  #   
  def index
      @venues = load_venues
      @events = load_events
      @completed_events = load_completed_events
  end

  ##
  # renders a screen where an agent can change the details stored about 
  # a particular venue.
  # 
  def edit_venue
      @venue = Venue.find(params[:id])
  end
  
  ##
  # Allows an agent to create a new venue.
  # 
  def create_venue
    if request.post?
        @venue = Venue.new(params[:venue])
        if @venue.save          
          redirect_to :controller => 'agents', :action => 'index'
        else
          render :action => 'create_venue'
        end
    else
        @venue = Venue.new
        @venue.country = User.find(session[:user_id]).country
        @venue.county = User.find(session[:user_id]).county
        @venue.city = User.find(session[:user_id]).city
        @venue.postcode = User.find(session[:user_id]).postcode           
    end
  end
  
  ##
  # Does the actual update to a venues details
  # 
  def update_venue        
    @venue = Venue.find(params[:venue][:id]) 
    if @venue.update_attributes(params[:venue])          
      redirect_to :action => 'index'
    else
      render :action => 'edit_venue', :id => params[:venue][:id]
    end
  end  

  ##
  # upload an image related to a venue
  # 
  def upload_image
    @venue = Venue.find(params[:id])
    if request.post? 
      # picture too big or wrong format return
      if params[:picture][:uploaded_picture] == ''
        flash[:image] = Resource.get("venue_image_instructions")
        return
      end  
      # if a picture exists its an update
      if @venue.image > 0 and Picture.find(@venue.image)
        @picture = Picture.find(@venue.image)
        if @picture.update_attributes(params[:picture])    
          @picture = nil
          @picture = Picture.find(@venue.image)
          # all ok
          @picture_available = 1
        end     
      # otherwise its a new image
      else      
         @picture = Picture.new(params[:picture])
         if @picture.save     
          @venue.image = @picture.id
          @venue.save
          @picture = nil
          @picture = Picture.find(@venue.image)
          # saved
          @picture_available = 1
        end      
      end  
    # request via get
    else 
      # if a picture exists add to assigns hash
      if @venue.image > 0 and Picture.find(@venue.image)
        @picture = Picture.find(@venue.image)
        @picture_available = 1
      else
        @picture = nil
        @picture_available = nil
      end
      @venue      
    end    
  end
  
  ##
  # creates a new event if POST,
  # renders the screen to add an event otherwise.
  # 
  def create_event
    if request.post?
         @event = Event.new(params[:event])
         @venue = Venue.find(params[:event][:venue_id])
        if @event.save          
          redirect_to :action => 'index'
        end 
    else
      @venue= Venue.find(params[:id])
      @event = Event.new 
    end
  end

  ##
  # Renders a screen to update a venues details
  # 
  def update_event
    if request.post?
      @event = Event.find(params[:id])
      @venue= Venue.find(@event.venue_id)
      
      if @event.update_attributes(params[:event])
        redirect_to :action => 'index'
      end    
    else        
        @event = Event.find(params[:id]) 
        @venue= Venue.find(@event.venue_id) 
    end
  end
  
  ##
  # deletes an event fromn the system
  # 
  def destroy_event
    Agent.destroy_event @params[:id]
    redirect_to  :controller => 'agents', :action => 'index' 
  end
  
  ##
  # deletes a venue from the system
  # 
  def destroy_venue
    Agent.destroy_venue @params[:id]  
    redirect_to  :controller => 'agents', :action => 'index'
  end
  
  private 
  ##
  # function to load all venues registered to the current user.
  # 
  def load_venues
    @venues = Venue.find(:all, 
                         :conditions => [ "user_id = ?", session[:user_id]])
  end 
  
  ##
  # function to load all pending events registered to the current user.
  #   
  def load_events
    @events = Event.find(:all, 
                         :conditions => ["user_id = "\
                         "#{session[:user_id]} and (begins >= CURRENT_DATE()"\
                         "or ends >= CURRENT_DATE())"] ,
                         :order => 'begins ASC')
  end 

  ##
  # function to load all completed events registered to the current user.
  #     
  def load_completed_events
    @completed_events = Event.find(:all, 
                         :conditions => ["user_id = "\
                         "#{session[:user_id]} and ends < CURRENT_DATE()"] ,
                         :order => 'begins ASC')
  end 
  
end
