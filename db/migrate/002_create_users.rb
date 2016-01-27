##
# app/db/migrate/002_create_users.rb
##
class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :username, :string, :null => false, :limit => 16
      t.column :hashed_password, :string
      t.column :salt, :string
      t.column :email, :string, :null => false, :limit => 64
      t.column :fname, :string, :limit => 16
      t.column :lname, :string, :limit => 16
      t.column :city, :string, :limit => 32
      t.column :county, :string, :limit => 32
      t.column :country, :string, :limit => 32
      t.column :postcode, :string, :limit => 32
      t.column :telephone, :string, :limit => 32
      t.column :suspended, :boolean, :default => false
      t.column :created_at, :timestamp
      t.column :suspended_at, :date
      t.column :suspended_by, :string, :limit => 16
      t.column :reason_suspended, :string, :limit => 32
      t.column :restored_at, :date
      t.column :restored_by, :string, :limit => 16
      t.column :reason_restored, :string, :limit => 32
      t.column :level, :integer, :default => 0
      t.column :status_changed_at, :date 
      t.column :status_changed_by, :string, :limit => 16
      t.column :status_changed_reason, :string, :limit => 32
    end
 end

  def self.down
    drop_table :users
  end
end