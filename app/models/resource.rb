class Resource < ActiveRecord::Base

  validates_presence_of :name
  validates_uniqueness_of :name, :message => "variable already in db"
  
  
  def self.get(n)
    begin 
     @resource = Resource.find_by_name(n)
     if @resource.value =~ /\w*/i
        @resource.value
     else
        "<b class='missing-resource'>(#{n})</b>"
     end    
    rescue
     @resource = Resource.new
     @resource.name = n
     @resource.save
     "<b class='missing-resource'>(#{n})</b>"
    end
  end 
end
