##
# The Resources Controller abstracts away from the Admin Controller the 
# responsibility for appliaction resources.
# 
class ResourcesController < ApplicationController
  layout 'whatshappnin'

  ##
  # ensures that the controller only responds to requests
  # that come via an HTTP POST.
  # 
  verify :method => :post, :only => [ :destroy_resource, 
                                      :create, 
                                      :update, 
                                      :destroy_all_resources ],
         :redirect_to => { :controller => 'admin', :action => 'index' }

  ##
  # Renders a form for adding a new resource.
  #
  def new
    @resource = Resource.new
  end
  
  ##
  # creates a new resource and saves it to the db .
  #
  def create
    @resource = Resource.new(params[:resource])
    if @resource.save
      flash[:notice] = 'Resource was successfully created.'
      redirect_to :controller => 'admin', :action => 'show_resources'
    else
      flash[:notice] = 'Resource not created.'
      render :action => 'new'
    end
  end

  ##
  # Renders a form for editing a resource.
  #
  def edit
    @r = Resource.find(params[:id])
  end

  ##
  # Updates a resource.
  #
  def update
    @resource = Resource.find(params[:id])
    i = 0
    Resource.find(:all, :order => 'name').each do |r|
      if r.name == @resource.name
        break
      else
        i = i + 1
      end
    end
    x = 0
    count = 1
    while x < Resource.count
      x = x + Resource.get("resources_paginator_count").to_i
      if i < x        
        break
      else
        count = count + 1
      end
    end
    if @resource.update_attributes(params[:r])
      redirect_to "http://whatshappnin.info/admin/show_resources?page=#{count}"     
    else
      flash[:notice] = 'Resource not updated.'
      render :action => 'edit', :id => params[:id]
    end    
  end  

  ##
  # Destroys a resource.
  #
  def destroy_resource
    Resource.find(params[:id]).destroy
    redirect_to :controller => 'admin', :action => 'show_resources'
  end
 
  ##
  # Destroys all resources.
  # 
  def destroy_all_resources
    if request.post?
      Resource.find(:all).each do|res|
        res.destroy
      end        
    end
    redirect_to :controller => 'admin', :action => 'show_resources'
  end

end
