##
# app/db/migrate/007_create_pictues.rb
##
class CreatePictures < ActiveRecord::Migration
  def self.up
    create_table :pictures do |t|
      t.column :owner_id, :integer, :null => true
      t.column :content_type, :string
      t.column :name, :string
      t.column :data, :binary, :limit => 5.megabytes
     end
   end

  def self.down
    drop_table :pictures
  end
end
