class Comment < ActiveRecord::Base
  has_one :venue
  has_one :event
end
