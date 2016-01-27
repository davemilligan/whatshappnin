class RegistrationMailer < ActionMailer::Base

  def registered(patron)
      @subject        = 'registration Complete'
      @body["patron"] = patron
      @recipients     = patron.email
      @from           = 'customerservices@whatshappnin.info'
      @sent_on        = Time.now
  end
  
  def password_changed(patron)
      @subject        = 'your password has been changed'
      @body["patron"] = patron
      @recipients     = patron.email
      @from           = 'customerservices@whatshappnin.info'
      @sent_on        = Time.now  
  end

  def password_reset(patron)
      @subject        = 'your password has been reset'
      @body["patron"] = patron
      @recipients     = patron.email
      @from           = 'customerservices@whatshappnin.info'
      @sent_on        = Time.now  
  end
   
  def username_reminder(patron)
      @subject        = 'reminder'
      @body["patron"] = patron
      @recipients     = patron.email
      @from           = 'customerservices@whatshappnin.info'
      @sent_on        = Time.now
  end 

  def upgrade_to_agent(patron)
      @subject        = 'your account has been upgraded'
      @body["patron"] = patron
      @recipients     = patron.email
      @from           = 'customerservices@whatshappnin.info'
      @sent_on        = Time.now
  end 
  
  def refuse_upgrade_to_agent(patron)
      @subject        = 'your upgrade request has been refused'
      @body["patron"] = patron
      @recipients     = patron.email
      @from           = 'customerservices@whatshappnin.info'
      @sent_on        = Time.now  
  end
end
