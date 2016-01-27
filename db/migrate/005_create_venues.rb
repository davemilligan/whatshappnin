##
# app/db/migrate/005_create_venues.rb
##
class CreateVenues < ActiveRecord::Migration
  def self.up    
    create_table :venues do |t|
      t.column :user_id, :integer, :null => false
      t.column :title, :string, :null => false, :limit => 32
      t.column :street, :string, :null => false, :limit => 32
      t.column :city, :string, :null => false, :limit => 32
      t.column :county, :string, :null => false, :limit => 32
      t.column :country, :string, :null => false, :limit => 32      
      t.column :postcode, :string, :null => false, :limit => 32
      t.column :v_type, :string, :null => false     
      t.column :description, :string, :null => false, :limit => 5000
      t.column :image, :integer, :default => 0   
    end 
  end

  def self.down
    drop_table :venues
  end
end
