##
#  The Welcome Controller  handles the initial request to the application.  
#  Currently this only involves the display of the Welcome screen but the scope 
#  of this controller shall be expanded to include other activities not 
#  directly associated with existing controllers.  
#  All users will have the same access to the functionality of the 
#  Welcome Controller.
#  
class WelcomeController < ApplicationController
  layout 'whatshappnin'
  ## 
  # the index action renders the default welcome screen for the application
  def index
    
  end
  
  ##
  # 
  def signin
    if session[:user_id]                  # if logged in skip
      flash.now[:notice] = Resource.get("already_signed_in")
      render :action => 'index'
      return
    end
    
    if request.post?
      user = User.authenticate(params[:username], params[:password])

      if user        
        session[:user_id] = user.id       
        uri = session["original_uri"]
        session["original_uri"] = nil
        # redirect to a refused uri now logged in
        redirect_to(uri || { :controller => 'welcome', :action => 'index' } )
      else
        flash.now[:notice] = Resource.get("invalid_username_password")  
      end
    end 
  end  

  ##
  # attempts to register a new user, the validation in the User object
  # will not permit the user to be created if validation fails.
  # Once successful the controller will send an email with details
  # of how to log in.
  #
  def register
    @user = User.new
    if request.post?
      @user = User.new(params[:user])
      @user.password = random_password
      if @user.save
        begin
              email = RegistrationMailer.create_registered(@user)
              flash[:heading] = Resource.get("reg_complete_heading") 
              flash[:message] = Resource.get("reg_complete_msg")                
              # all ok
              send_and_redirect email, 'welcome', 'notify'
        rescue 
              @user.destroy 
              flash[:heading] = Resource.get("reg_problem_heading")
              flash[:message] = Resource.get("reg_problem_msg")
              # could save but could not email
              redirect_to :action => 'notify'
        end
      else
    
      end
    end    
  end 
  
  ##
  # processes a request to upgrade the current users status
  # from patron to agent.
  #
  def upgrade
    if request.post?
      @user = User.find(session[:user_id])
      @user.telephone = params[:telephone]
      @user.update
      @req = UpgradeRequest.new
      @req.user_id = session[:user_id]
      if @req.save
        flash[:notice] = Resource.get("upgrade_req_recieved")       
      else
        return
      end
      redirect_to :action => 'index'
    end
  end
  
  ##
  # Removes the user_id variable fron the session if it exists.
  # 
  def signout
    if session[:user_id]
      session[:user_id] = nil     
    end
    redirect_to :controller => 'welcome', :action => 'index' 
  end 
  
  ##
  # If the user has submitted a valid username in the request this method will
  # send a new random password to the user's registered email address.
  # 
  def forgot_password 
    if request.post?
      @user = User.find_by_username(params[:username])
      if !@user
        @user = User.find_by_email(params[:username])
        if !@user
          flash.now[:notice] = Resource.get("username_not_found")
          return
        end       
      end
      
      if @user.suspended
          flash.now[:notice] = Resource.get("account_suspended")
          return
      end 
          
      @user.password = random_password
      if @user.update
        begin
          email = RegistrationMailer.create_password_reset(@user)
          flash[:heading] = Resource.get("password_reset_heading") 
          flash[:message] = Resource.get("password_reset_msg")
          send_and_redirect email, 'welcome', 'notify'
        rescue 
          flash[:heading] = 
            Resource.get("password_changed_fail_heading")
          flash[:message] = 
            Resource.get("password_changed_fail_msg ")
          redirect_to :action => 'notify'
        end 
      else
         flash[:heading] = 
            Resource.get("password_changed_fail_heading ") 
         flash[:message] = 
            Resource.get("password_changed_fail_msg ")
         redirect_to :action => 'notify'
      end         
    end
  end
  
  ##
  # If the user has submitted a valid email address in the request this method 
  # will send a reminder to the users registered email address.
  #   
  def forgot_username    
    if request.post?
      @user = User.find_by_email(params[:email])
      if !@user
        flash.now[:notice] = Resource.get("email_not_found")
        return
      end       
      
      if @user.suspended
          flash.now[:notice] = Resource.get("account_suspended")
          return
      end 

      begin
            email = RegistrationMailer.create_username_reminder(@user)
            flash[:heading] = Resource.get("username_sent_hdg") 
            flash[:message] = Resource.get("username_sent_msg")
            send_and_redirect email, 'welcome', 'notify'
      rescue 
            flash[:heading] = Resource.get("username_sent_hdg ") 
            flash[:message] = Resource.get("username_sent_msg ")
            redirect_to :action => 'notify'
      end 
    end  
  end 
  
  ##
  # Renders the currently active questionaire in a form for
  # the user to provide feedback.
  #
  def feedback
    @questionaire = Questionaire.find(which_questionaire)
    @questionaire_answer = QuestionaireAnswer.new
  end
  
  ##
  # Processes the questionaire submitted by a user
  #
  def submit_feedback
    @questionaire_answer = QuestionaireAnswer.new
    @questionaire_answer.quest_id = which_questionaire
    @questionaire_answer.user_id = session[:user_id]
    @questionaire_answer.comments = params[:questionaire_answer][:comments]
    @questionaire_answer.q1 = params[:questionaire_answer_q1][:true]
    @questionaire_answer.q2 = params[:questionaire_answer_q2][:true]
    @questionaire_answer.q3 = params[:questionaire_answer_q3][:true]
    @questionaire_answer.q4 = params[:questionaire_answer_q4][:true]
    @questionaire_answer.q5 = params[:questionaire_answer_q5][:true]
    @questionaire_answer.q6 = params[:questionaire_answer_q6][:true]
    @questionaire_answer.q7 = params[:questionaire_answer_q7][:true]
    @questionaire_answer.q8 = params[:questionaire_answer_q8][:true]
    @questionaire_answer.q9 = params[:questionaire_answer_q9][:true]
    @questionaire_answer.q10 = params[:questionaire_answer_q10][:true]
    @questionaire_answer.save
    @questionaire = Questionaire.find(which_questionaire)
    @questionaire.responses = @questionaire.responses + 1
    @questionaire.save
    flash[:notice] = Resource.get('feedback_thanks_msg')
    redirect_to :action => 'index'
  end
  
  ##
  # loads the about screen.
  #
  def contact
  
  end
   
  ##
  # Handles confirmation/notification messages
  #    
  def notify  
  end 
  
  ##
  # helper to find the active questionaire.
  # 
  def which_questionaire
    @q = 0
    Questionaire.find(:all).each do|q|
     if q.activated
      @q = q.id
      break
     end
    end 
    return @q 
  end    
end
