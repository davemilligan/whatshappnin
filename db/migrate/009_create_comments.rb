##
# app/db/migrate/009_create_comments.rb
##
class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.column :subject, :string
      t.column :subject_id, :integer
      t.column :title, :string
      t.column :content, :text, :null => false, :limit => 500
      t.column :created_at, :datetime, :null => false
      t.column :user_id, :integer, :null => false
      t.column :deleted, :boolean, :default => false
      t.column :deleted_by, :string
      t.column :date_deleted,  :date
      t.column :reply, :string, :limit => 500
      t.column :updated_at, :timestamp
      t.column :updated, :boolean
    end
  end

  def self.down
    drop_table :comments
  end
end
