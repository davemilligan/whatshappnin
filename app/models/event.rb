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
