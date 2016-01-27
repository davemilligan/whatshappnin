##
#  The Admin Controller allows an administrator to interact with the 
#  application, adding updating and deleteing patrons, 
#  agents and appliaction resources. 
#  
class AdminController < ApplicationController
  helper 'search' 
  before_filter :authorize_admin
  layout 'whatshappnin'
 

  ##
  #  the default action
  #    
  def index
     redirect_to :action => 'show_resources'                                                                                                   
  end
  
  ##
  #  Renders application resources, paginated 50 at a time
  #    
  def show_resources
    @resources_pages = Paginator.new self, 
                        Resource.count, 
                        Resource.get("resources_paginator_count").to_i, 
                        params[:page]   
    @resources = Resource.find :all, :order => 'name',
                           :limit  =>  @resources_pages.items_per_page,
                           :offset =>  @resources_pages.current.offset    
  end

  ##
  #  Renders registered patrons, paginated 10 at a time
  #      
  def show_patrons
    @patrons_pages, @patrons = paginate(:users, 
                                        :conditions => ['level = 0'],
                                        :order => 'username')    
  end
  
  ##
  #  Renders registered patrons, paginated 10 at a time
  #      
  def show_questionaires
    @quests_pages, @quests = paginate(:questionaires,
                                        :order => 'created_at')    
  end

  def show_feedback    
    @feedback = QuestionaireAnswer.find_all_by_quest_id(params[:id])
    @questions = Questionaire.find(params[:id])   
  end

  ##
  #  Renders registered admins, paginated 10 at a time
  #      
  def show_agents
    @agents_pages, @agents = paginate(:users, 
                                      :conditions => ['level = 1'],
                                      :order => 'username')    
  end
  
  ##
  #  Renders registered admins, paginated 10 at a time
  #      
  def show_admins
    @admins_pages, @admins = paginate(:users, 
                                      :conditions => ['level = 2'],
                                      :order => 'username')  
  end

  ##
  #  Renders comments, paginated 100 at a time
  #      
  def show_comments
    @comments = Comment.find_by_sql("select * from comments where subject_id order by created_at DESC")
    @replies = []
    @comments.each do|c|      
      Comment.find_all_by_reply(c.id).each do|r|
        @replies << r
      end
    end 
  end
 
  ##
  #  Renders comments, paginated 100 at a time
  #      
  def show_upgrade_requests
    if params[:id] == 'true'
      @reqs = UpgradeRequest.find(:all, :conditions => "processed = 0")
      @pending = 1
    else
      @reqs = UpgradeRequest.find(:all, :conditions => "processed = 1")
    end
  end
 
  ##
  #  marks a patron suspended from the system
  #       
  def suspend_admin
    Admin.suspend params[:id]
    redirect_to :action => 'show_admins'    
  end

  ##
  #  restores a deleted admin to active the system
  #    
  def restore_admin
    Admin.restore params[:id]
    redirect_to :action => 'show_admins'    
  end 
  
  ##
  #  marks a patron suspended from the system
  #       
  def suspend_patron
    Admin.suspend params[:id]
    redirect_to :action => 'show_patrons'    
  end

  ##
  #  restores a deleted patron to active the system
  #    
  def restore_patron
    Admin.restore params[:id]
    redirect_to :action => 'show_patrons'    
  end
  
  ##
  #  marks an agent deleted from the system
  #    
  def suspend_agent
    Admin.suspend params[:id]
    redirect_to :action => 'show_agents'    
  end

  ##
  #  restores a deleted agent to the system
  #    
  def restore_agent
    Admin.restore params[:id]
    redirect_to :action => 'show_agents'    
  end

  ##
  #  changes a users status to administrator
  #   
  def level_to_admin
    Admin.to_admin params[:id]
    redirect_to :action => 'show_admins'   
  end

  ##
  #  changes a users status to agent
  #    
  def level_to_agent
    Admin.to_agent params[:id]
    redirect_to :action => 'show_agents'   
  end

  ##
  #  changes a users status to agent and emails them.
  #    
  def upgrade_to_agent
    @user = UpgradeRequest.find_by_user_id(params[:id])
    @user.processed = true
    @user.processed_by = session[:user_id]
    @user.processed_at = Date.today
    @user.refused = false
    @user.save
    @user = User.find(@user.user_id)
    UpgradeRequest.find_by_user_id(params[:id]).destroy
    Admin.to_agent(params[:id])
    email = RegistrationMailer.create_upgrade_to_agent(@user)
    email.set_content_type("text/html")
    RegistrationMailer.deliver(email)
    redirect_to :action => 'show_upgrade_requests', :id => true   
  end

  ##
  #  refuses an upgrade and sends a notification email.
  #   
  def deny_upgrade
    @user = UpgradeRequest.find_by_user_id(params[:id])
    @user.processed = true
    @user.processed_by = session[:user_id]
    @user.processed_at = Date.today
    @user.refused = true
    @user.save
    @user = User.find(@user.user_id)
    email = RegistrationMailer.create_refuse_upgrade_to_agent(@user)
    email.set_content_type("text/html")
    RegistrationMailer.deliver(email)
    redirect_to :action => 'show_upgrade_requests', :id => true   
  end
 
  ##
  #  changes a users status to patron
  #  
  def level_to_patron
    Admin.to_patron params[:id]
    redirect_to :action => 'show_patrons'   
  end  
  private
end
