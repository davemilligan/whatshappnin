class PrivateEventController < ApplicationController
  helper 'search'
  layout 'whatshappnin' 
  
  ##
  #  first line of defence for unauthorized access
  #  
  before_filter :authorize_user  
  
  ##
  # loads all events for a user
  # 
  def events
    load_private_events
    load_completed_private_events
  end
  
  ##
  # loads a private event, and all associated guest lists,
  # comments and replies.
  # 
  def private_event
    @event = PrivateEvent.find(params[:id])
    @reg_guest_list = find_registered_guests(@event.id)
    @unreg_guest_list = find_unregistered_guests(@event.id)  
    @comments = get_comments("private_event", @event.id)
    @replies = []
    @comments.each do|c|      
      Comment.find_all_by_reply(c.id).each do|r|
        @replies << r
      end
    end 
  end
  
  ##
  # if request comers via a GET 
  #   creates a new private_event object and populates 
  #   some fields according to the agents locale
  # if request comes via a POST
  #   is saves the private_event to the database
  def create_event
    if request.post?
         @event = PrivateEvent.new(params[:event])
        if @event.save          
          redirect_to :action => 'events'
        end 
    else
      @event = PrivateEvent.new
      @event.county = User.find(session[:user_id]).county
      @event.city = User.find(session[:user_id]).city
      @event.country = User.find(session[:user_id]).country
      @event.postcode = User.find(session[:user_id]).postcode       
    end
  end

  ##
  # Renders a screen to update a venues details
  # 
  def update_event
    if request.post?
      @event =  PrivateEvent.find(params[:id])
      if @event.update_attributes(params[:event])
        redirect_to :action => 'events'
      end    
    else        
        @event = PrivateEvent.find(params[:id])
    end
  end

  ##
  # passes a reference to the view which uses these
  # to call helper functions
  # 
  def event
    @event
    @comments
    @replies     
  end
  
  ##
  # checks that the invited person is not already listed
  # before sending an email withn details about how
  # to log in.
  # 
  def invite
    if request.post?
      @pi = PrivateInvite.new(params[:pi])      
      if @pi.email == User.find(session[:user_id]).email
          flash[:notice] = "you are already listed"
          redirect_to :back
          return     
      end     
      PrivateInvite.find_all_by_private_event_id(@pi.private_event_id).each do |p|
        if p.email == @pi.email
          flash[:notice] = "#{@p.email}is already on the guest list"
          redirect_to :back
          return     
        end
      end
      
      @pi.invited_at = Date.today      
      invite = Invitation.new
      invite.title = PrivateEvent.find(@pi.private_event_id).title
      invite.host_email = User.find(session[:user_id]).email
      invite.guest_email = @pi.email   
      email = InvitationMailer.create_invite(invite)
      email.set_content_type("text/html")
      @guest_list = PrivateInvite.find(:all)
      if @pi.save
        begin
          InvitationMailer.deliver(email)        
        rescue
          @pi.destroy
          flash[:notice] = "address not found"
        end   
      end          
    end
    redirect_to :back
  end

  ##
  # upload an image related to a venue
  # 
  def upload_image
    @event = PrivateEvent.find(params[:id])
    if request.post? 
      # picture too big or wrong format return
      if params[:picture][:uploaded_picture] == ''
        flash[:image] = Resource.get("venue_image_instructions")
        return
      end  
      # if a picture exists its an update
      if @event.image > 0 and Picture.find(@event.image)
        @picture = Picture.find(@event.image)
        if @picture.update_attributes(params[:picture])    
          @picture = nil
          @picture = Picture.find(@event.image)
          # all ok
          @picture_available = 1
        end     
      # otherwise its a new image
      else      
         @picture = Picture.new(params[:picture])
         if @picture.save     
          @event.image = @picture.id
          @event.save
          @picture = nil
          @picture = Picture.find(@event.image)
          # saved
          @picture_available = 1
        end      
      end  
    # request via get
    else 
      # if a picture exists add to assigns hash
      if @event.image > 0 and Picture.find(@event.image)
        @picture = Picture.find(@event.image)
        @picture_available = 1
      else
        @picture = nil
        @picture_available = nil
      end
      @event      
    end    
  end

 
  private
  ##
  # loads a users private events still current
  # 
  def load_private_events
    email = User.find(session[:user_id]).email
    @events = PrivateEvent.find_by_sql("select * from private_events as pe where pe.id in (select distinct pe.id from private_events as pe left join private_invites as pi on pe.id = pi.private_event_id  where ((pi.email = '#{email}') or (pe.user_id = '#{session[:user_id]}')) and  ((begins >= CURRENT_DATE() or ends >= CURRENT_DATE())))") 
    
  end 
  ##
  # loads a users private events that have now passed
  # 
  def load_completed_private_events
    email = User.find(session[:user_id]).email
    @completed_events = PrivateEvent.find_by_sql("select * from private_events as pe where pe.id in (select distinct pe.id from private_events as pe left join private_invites as pi on pe.id = pi.private_event_id  where ((pi.email = '#{email}') or (pe.user_id = '#{session[:user_id]}')) and  ((begins < CURRENT_DATE() and ends < CURRENT_DATE())))") 
  end 
  
  ##
  # loads an array with the usernames of invited guests
  # who are already registered with whatshappnin.
  # 
  def find_registered_guests(id)
    @reg_guests = []
    @reg_guests <<  User.find(@event.user_id).username
    PrivateInvite.find_all_by_private_event_id(@event.id).each do |g|
      if User.find_by_email(g.email)
        @reg_guests << User.find_by_email(g.email).username
      end
    end
    @reg_guests     
  end
  
  ##
  # loads an array with the usernames of invited guests
  # who are not yet registered.
  # 
  def find_unregistered_guests(id)
    @unreg_guests = []
    PrivateInvite.find_all_by_private_event_id(@event.id).each do |g|
      if !User.find_by_email(g.email)
        @unreg_guests << g.email
      end
    end
    @unreg_guests  
  end
  
  def get_replies
  
  end
  
  
end
