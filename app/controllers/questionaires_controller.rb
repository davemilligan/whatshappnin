class QuestionairesController < ApplicationController
  before_filter :authorize_admin
  layout 'whatshappnin'
  def index
    list
    render :action => 'list'
  end



  ##
  # ensures that the controller only responds to requests
  # that come via an HTTP POST.
  # 
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :controller => 'admin', :action => 'show_questionaires' }

  def new
    @questionaire = Questionaire.new
  end

  def create
    @questionaire = Questionaire.new(params[:questionaire])
    @questionaire.created_by = session[:user_id]
    if @questionaire.save      
      redirect_to :controller => 'admin', :action => 'show_questionaires'
    else
      render :action => 'new'
    end
  end

  def edit
    @questionaire = Questionaire.find(params[:id])
  end

  def update
    @questionaire = Questionaire.find(params[:id])
    @questionaire.created_by = session[:user_id]
    if @questionaire.update_attributes(params[:questionaire])
      redirect_to :controller => 'admin', :action => 'show_questionaires'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Questionaire.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  ##
  # marks a specified questionaire as the one we wish to use on site
  # 
  def activate
    Questionaire.find(:all).each do |q|
      q.activated = false
      q.save
    end
    @questionaire = Questionaire.find(params[:id])
    @questionaire.activated = true
    @questionaire.save
    redirect_to :controller => 'admin', :action => 'show_questionaires'    
  end
end
