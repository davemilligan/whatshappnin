##
# Class Admin handles some functionality for the AdminController.
# 
# It is used to migrate a users status up and down through the 
# different authorization levels.
##
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

##
# 
# Class Agent performs some tasks for the AgentController.
# 
# Destroys events and venues with associated comments
#
##
class Agent
  
  def self.destroy_event(id)
    begin
      @event = Event.find(id)
      Comment.find_all_by_subject_id(@event.id).each do |c|
        Comment.delete_all(["reply = ?", @c.id])      
      end
      Comment.delete_all(["subject_id = ?", @event.id])
      @event.destroy    
    rescue
      
    end
  
  end  

  def self.destroy_venue(id)
    begin
      @venue = Venue.find(id)    
      Event.find_all_by_venue_id(@venue.id).each do |e|
        Comment.find_all_by_subject_id(e.id).each do |c|
          Comment.delete_all(["reply = ?", @c.id])      
        end
        Comment.delete_all(["subject_id = ?", e.id])
        e.destroy
      end
      Comment.find_all_by_subject_id(@venue.id).each do |c|
        Comment.delete_all(["reply = ?", @c.id])      
      end
      Comment.delete_all(["subject_id = ?", @venue.id])
      @venue.destroy 
   rescue
    
   end
  
  end  
  
end

##
# Class event is a base class for the event data model.
# This class simply provides validation for the event model.
##

class Event < ActiveRecord::Base
  has_one :venue
  has_many :comments
  validates_presence_of :title, :e_type, :description, :begins, :ends
  validates_presence_of :street, :city, :county, :country, :postcode
  
  def validate
    if begins and ends and begins > ends
      errors.add(:begins , "An event can't start after it ends")
    end
    if begins and ends and begins < Date.today
      errors.add(:begins , "You have entered a date BEFORE today")
    end    
  end
                   
end

##
# Class InvitationMailer sole responsibility id to render populated 
# data to the actual email template.  ActionMailer looks after the
# sending of the actual email.
#
##
class InvitationMailer < ActionMailer::Base

  def invite(invite)
      @subject        = invite.title
      @body["invite"] = invite
      @recipients     = invite.guest_email
      @from           = invite.host_email
      @sent_on        = Time.now
  end
  
end

##
# Class Invitaion is a hepler class used by the 
# private_event_controller.
##
class Invitation
    attr_reader :host_email, :guest_email, :title
    attr_writer :host_email, :guest_email, :title
end

##
# Class Picture is the data model for the Picture Object.
# Uploaded images are stored in the database and this class
# contains the validation for that table.
##
class Picture < ActiveRecord::Base
  has_one :agent
  has_one :patron
  has_one :venue
  has_one :event
  validates_format_of :content_type,    
                      :with    => /^image/,    
                      :message => "you can only upload images"
  
  max = Resource.get("venue_max_image_size").to_i/1024
  validates_length_of :data, :maximum => 102400, :message => "less than #{max} KB if you don't mind"

  def uploaded_picture=(image_url)
    self.name   = base_part_of(image_url.original_filename)
    self.content_type = image_url.content_type.chomp
    self.data = image_url.read
  end
  
  def base_part_of(file_name)
    File.basename(file_name).gsub(/[^\w._-]/, '')
  end
end

##
# Class PrivateEvent is the data model for the PrivateEvent model.
#
# The class carries out the validation for the model.
##

class PrivateEvent < ActiveRecord::Base
  has_many :private_invites
  validates_presence_of :title, :venue, :description, :begins, :ends
  validates_presence_of :street, :city, :county, :country, :postcode

  def validate
    if begins and ends and begins.to_date > ends
      errors.add(:begins , "An event can't start after it ends")
    end
    if begins and ends and begins < Date.today
      errors.add(:begins , "You have entered a date BEFORE today")
    end 
  end
end

##
#  Class RegistrationMailer manages the email requirements of the 
#  WelcomeController.
#  
#  Each action corresponds to a view of the same name.  The view
#  serves as the template for the email.
#  
#  ActionMailer looks after the delivery.
##
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

##
# Class Resource represents the Resource data model.
# It is used to maintain application resources in different languages.
# 
# The language utility has yet to be implemented.
# 
##
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

##
# Class User represents the User data model.
# 
# All application users are represented by this object.
# Access level to the application is governed by the level
# attribute of this object.
##
require 'digest/sha1'
class User < ActiveRecord::Base
  validates_presence_of     :username, :email
  validates_presence_of :password, :on => :create
  validates_uniqueness_of   :username, :message => "username in use"
                            
  validates_uniqueness_of   :email, :message => "address already in use"
  validates_format_of :email,
                      :with =>   /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/,
                      :message => 'email address appears invalid'
  
  validates_uniqueness_of   :email, :message => "address already in use"
  
  validates_format_of :username,
                      :with =>   /^[a-zA-Z0-9]{5,50}$/i,
                      :message => "Usernames should be between 6 and 50"\
                                  " characters long, case insensitive, "\
                                  " and no spaces."  
                                         
  attr_accessor :email_confirmation
  validates_confirmation_of :email  
 
  def validate
    errors.add_to_base("Missing password") if hashed_password.blank?
  end
  
  def self.authenticate(username, password)
    user = self.find_by_username(username)
    if !user
      user = self.find_by_email(username)
    end 
    if user
      expected_password = encrypted_password(password, user.salt)
      if (user.hashed_password != expected_password) or user.suspended
        user = nil
      end
    end 
    user
  end
  
  def password
    @password
  end
  
  def password=(pwd)
    @password = pwd
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end
  
  private 
  def self.encrypted_password(password, salt)
    string_to_hash = password + "wibble" + salt #wibble = randomer
    Digest::SHA1.hexdigest(string_to_hash)
  end
  
  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
end


##
# Class Venue represents the Venue User model.
# 
##
class Venue < ActiveRecord::Base
  has_one :user
  has_many :events
  has_one :venue_type
  has_one :picture
  has_many :comments
  validates_presence_of :title,:v_type, :description
  validates_presence_of :street, :city, :county, :country, :postcode
  
  def validate
  end
end