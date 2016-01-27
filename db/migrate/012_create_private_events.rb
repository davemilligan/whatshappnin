##
# app/db/migrate/012_create_private_events.rb
##
class CreatePrivateEvents < ActiveRecord::Migration
  def self.up
    create_table :private_events do |t|
      t.column :user_id, :integer, :null => false
      t.column :venue, :string, :null => false
      t.column :title, :string, :null => false, :limit => 32
      t.column :street, :string, :null => false, :limit => 32
      t.column :city, :string, :null => false, :limit => 32
      t.column :county, :string, :null => false, :limit => 32
      t.column :country, :string, :null => false, :limit => 32
      t.column :postcode, :string, :null => false, :limit => 32
      t.column :description, :string, :null => false, :limit => 5000 
      t.column :image, :integer, :default => 0
      t.column :begins, :date
      t.column :ends, :date
    end
  end

  def self.down
    drop_table :private_events
  end
end