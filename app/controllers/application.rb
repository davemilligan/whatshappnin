#  Filters added to this controller will be run for all controllers in the 
#  application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  before_filter :set_language

  helper 'search' 
  
  ##
  # Sets the default language for the application.
  # feature not implmented fully yet
  # 
  def set_language
    session[:language] = 'english'
  end  
  
  ##
  # global home action
  # 
  def home
      redirect_to :controller => 'welcome', :action => 'index'
  end 
 
  private
  ##
  # ensures that a user has at least patron status(level 0)
  # 
  def authorize_user
    unless session[:user_id]
      session[:original_uri] = request.request_uri
      flash[:notice] = Resource.get("user_not_authorized_wo_login")
      redirect_to(:controller => "welcome", :action => "signin")
    end
  end  
 
  ##
  # ensures that a user has at least agent status(level 1)
  # 
  def authorize_agent
    unless session[:user_id] and
       User.find(session[:user_id]).level >= 1
        session[:original_uri] = request.request_uri
        flash[:notice] = Resource.get("agent_not_authorized_wo_login")
        redirect_to(:controller => "welcome", :action => "signin")
    end
  end

  ##
  # ensures that a user has admin status(level 2)
  #   
  def authorize_admin
    unless session[:user_id] and
        User.find(session[:user_id]).level == 2
        session[:original_uri] = request.request_uri
        flash[:notice] = Resource.get("access_denied")
        redirect_to(:controller => "welcome", :action => "signin")
    end
  end
   
  ##
  # Helper method to generate random passwords.
  # 
  def random_password
    chars = ("a".."z").to_a + ("1".."9").to_a 
    newpass = Array.new(8, '').collect{chars[rand(chars.size)]}.join
  end

  ##
  # handles exception thrown in the application
  #
  #def rescue_action(e) 
  #  redirect_to :controller => 'welcome', :action => 'index'     
  #end
  #
  ##
  # handles exception thrown in the application in production
  #  
  #def rescue_action_in_public(exception)
  #   case exception
  #   when ActionController::UnknownAction
  #     render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
  #   else
  #     logger.error "Error raised: " + exception.to_s
  #     render :file => "#{RAILS_ROOT}/public/500.html",  :status => 500
  #   end
  #end
  
  ##
  # Helper method to handle outgoing emails used in various controllers
  # 
   def send_and_redirect(email, controller , action_next)
    if email
      email.set_content_type("text/html")
      RegistrationMailer.deliver(email)
    end
    redirect_to  :controller => controller, :action => action_next
    # TODO remove render DDD
    #render(:text => "<pre>" + email.encoded + "</pre>")   
  end
 
  ##
  # Helper method to check passwords match. Used by profile_controller
  # and welcome_controller
  #   
  def passwords_dont_match(new_p, new_p_conf)
      if new_p != new_p_conf
        flash[:password] = Resource.get("passwords_mismatched")
        return true
      end 
      return false
  end
   
  ##
  # Helper method to check passwords are of the correct format. 
  # Used by profile_controller and welcome_controller
  #    
  def password_wrong_format(new_p)
    if new_p !~ /^[a-zA-Z]{5,14}$/
      flash[:password] = Resource.get("password_wrong_format")
      return true
    end
    return false
  end 

  ##
  # Helper method to check user input for illegal words and characters
  #     
  def validate_user_input(input)
    if input =~ "/(script)|(&lt;)|(&gt;)|(%3c)|(%3e)|(SELECT) |(UPDATE) |"\
                  "(INSERT) |(DELETE)|(GRANT) |(REVOKE)|(UNION)|(&amp;lt;)|"\
                  "(&amp;gt;)/"
      return nil
    end 
    return input 
  end 
  
  ##
  # handles bad urls
  # 
  def bad_route
    flash[:heading] = Resource.get("bad_route_hdg") 
    flash[:message] = Resource.get("bad_route_msg")
  end 
  
  ##
  # used when a venue, privateEvent or event are loaded to
  # gather all related comments.
  #   
  def get_comments(subj, id)
      comments = Comment.find_all_by_subject_id(id,
                                      :conditions => "subject = \"#{subj}\"",
                                      :order => 'updated_at  DESC')  
      comments.each do |c|
        com_log = CommentAccessLog.find_by_comment_id(c.id,
            :conditions => "(user_id = '#{session[:user_id]}')")
        if com_log
          com_log.accessed = Time.now
          if com_log.updated
            c.updated = true
            com_log.updated = false
          else
            c.updated = false
          end
          com_log.save
        else
          c.updated = true
          com_log = CommentAccessLog.new
          com_log.comment_id = c.id
          com_log.user_id = session[:user_id]
          com_log.accessed = Time.now
          com_log.updated = true
          com_log.save
        end
      end
      return comments
  end
end