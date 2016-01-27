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
