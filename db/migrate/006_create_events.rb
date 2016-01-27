##
# app/db/migrate/006_create_events.rb
##
class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.column :user_id, :integer, :null => false
      t.column :venue_id, :integer, :null => false
      t.column :title, :string, :null => false, :limit => 32
      t.column :street, :string, :null => false, :limit => 32
      t.column :city, :string, :null => false, :limit => 32
      t.column :county, :string, :null => false, :limit => 32
      t.column :country, :string, :null => false, :limit => 32
      t.column :postcode, :string, :null => false, :limit => 32
      t.column :e_type, :string, :null => false     
      t.column :description, :string, :null => false, :limit => 5000 
      t.column :image, :string 
      t.column :begins, :date
      t.column :ends, :date
    end
  end

  def self.down
    drop_table :events
  end
end
