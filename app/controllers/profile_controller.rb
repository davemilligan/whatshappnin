class ProfileController < ApplicationController
  before_filter :authorize_user
  layout 'whatshappnin'
 
  ##
  # ensures that the controller only responds to requests
  # that come via an HTTP POST.
  #  
  verify :method => :post, 
         :only => [ :update, :change_password, :view_profile ],
         :redirect_to => { :controller => 'welcome', 
                           :action => 'index' }   
  def edit_profile
      @user = User.find(session[:user_id])
  end
 
  def view_profile
      @user = User.find_by_username(params[:id])
  end
  
  def update
    begin
      @user = User.find(params[:id])
      @user.username = params[:user][:username]    
      @user.fname = params[:user][:fname]
      @user.lname = params[:user][:lname]
      @user.email = params[:user][:email]
      @user.city = params[:user][:city]
      @user.country = params[:user][:country]
      @user.postcode = params[:user][:postcode]
      if @user.update_attributes(params[:user])
          flash[:heading] = Resource.get("profile_update_heading") 
          flash[:message] = Resource.get("profile_update_msg") 
          redirect_to :action => 'changed'
          return               
      end     
    rescue
       
    end 
    render :action => 'edit_profile'
  end
  
  def change_password
    if password_wrong_format(params[:new_p]) or
              passwords_dont_match(params[:new_p], params[:new_p_conf])
        flash[:notice] = Resource.get("invalid_data")
        redirect_to :action => 'edit_profile'
        return
    end    
    @user = User.find(session[:user_id])
    @user = User.authenticate(@user.username, params[:old_p])
    if @user     
      @user.password = params[:new_p]
      if @user.update
        email = RegistrationMailer.create_password_changed(@user)
        email.set_content_type("text/html")          
        RegistrationMailer.deliver(email)
        flash[:heading] = Resource.get("password_reset_heading")
        flash[:message] = Resource.get("password_reset_msg")
      else
        flash[:heading] = Resource.get("password_changed_fail_heading")
        flash[:message] = Resource.get("password_changed_failure")
      end 
      redirect_to :action => 'changed'    
    else
        flash[:notice] = Resource.get("invalid_data")
        redirect_to :action => 'edit_profile'
    end
  end
  
  def changed  
  end
  

end
