##
# app/db/migrate/013_create_private_invites.rb
##
class CreatePrivateInvites < ActiveRecord::Migration
  def self.up
    create_table :private_invites do |t|
      t.column :private_event_id, :integer, :null => false
      t.column :email, :string, :null => false, :limit => 64
      t.column :invited_at, :datetime
      t.column :invited_by, :integer, :null => false
      t.column :uninvited_at, :datetime
      t.column :uninvited_by, :integer
    end
  end

  def self.down
    drop_table :private_invites
  end
end
