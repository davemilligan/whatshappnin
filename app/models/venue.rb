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
