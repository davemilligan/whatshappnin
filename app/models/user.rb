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
