class BackResource < ActiveRecord::Base

  validates_presence_of :name
  validates_uniqueness_of :name, :message => "variable already in db"
  
  
  def self.get(name)
    begin
     @resource = BackResource.find_by_name(name)
     if @resource.value =~ /\w*/i
        @resource.value
     else
        "<b class='missing-resource'>(#{name})</b>"
     end    
    rescue
     @resource = BackResource.new
     @resource.name = name
     @resource.save
     "<b class='missing-resource'>#{name}</b>"
    end
  end  
end
