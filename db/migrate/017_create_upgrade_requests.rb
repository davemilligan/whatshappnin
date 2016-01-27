##
# app/db/migrate/017_create_upgrade_requests.rb
##
class CreateUpgradeRequests < ActiveRecord::Migration
  def self.up
    create_table :upgrade_requests do |t|
      t.column :user_id, :integer, :null => false
      t.column :created_at, :datetime
      t.column :processed, :boolean, :default => false
      t.column :processed_at, :datetime
      t.column :processed_by, :integer
      t.column :comments, :string, :limit => 256 
      t.column :refused, :boolean, :default => false     
    end
  end

  def self.down
    drop_table :upgrade_requests
  end
end
