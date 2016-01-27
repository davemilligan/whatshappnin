class Admin

  def self.suspend(id)
      begin
      admin = User.find(id)
      admin.suspended = true
      admin.suspended_at = Date.today
      admin.suspended_by = "Admin"
      admin.reason_suspended = "Test"
      admin.update   
    rescue
      
    end
  end 
  
  def self.restore(id)
      begin
      admin = User.find(id)
      admin.suspended = false
      admin.restored_at = Date.today
      admin.restored_by = "Admin"
      admin.reason_restored = "Test"
      admin.update   
    rescue
      
    end
  end
  
  def self.to_patron(id)
    begin
      user = User.find(id)
      user.level = 0
      user.status_changed_at = Date.today
      user.status_changed_by = "Admin"
      user.status_changed_reason = "Test"
      user.update   
    rescue
      
    end
  end   

  def self.to_agent(id)
    begin
      user = User.find(id)
      user.level = 1
      user.status_changed_at = Date.today
      user.status_changed_by = "Admin"
      user.status_changed_reason = "Test"
      user.update   
    rescue
      
    end
  end 

  def self.to_admin(id)
    begin
      user = User.find(id)
      user.level = 2
      user.status_changed_at = Date.today
      user.status_changed_by = "Admin"
      user.status_changed_reason = "Test"
      user.update   
    rescue
      
    end
  end   
  
     
end
