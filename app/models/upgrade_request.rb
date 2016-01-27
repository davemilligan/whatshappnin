class UpgradeRequest < ActiveRecord::Base
  validates_presence_of     :user_id
  validates_uniqueness_of   :user_id, 
       :message => 'we already have an upgrade request on file for this user'
end
