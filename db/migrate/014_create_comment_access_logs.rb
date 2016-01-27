##
# app/db/migrate/014_create_comment_access_logs.rb
##
class CreateCommentAccessLogs < ActiveRecord::Migration
  def self.up
    create_table :comment_access_logs do |t|
      t.column :user_id, :integer
      t.column :comment_id, :integer
      t.column :updated, :boolean, :default => false
      t.column :accessed, :timestamp
    end
  end

  def self.down
    drop_table :comment_access_logs
  end
end
