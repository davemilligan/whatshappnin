##
# app/db/migrate/003_add_user_indices.rb
##
class AddUserIndices < ActiveRecord::Migration
  def self.up
      add_index :users , :username, :unique => true
      add_index :users , :email, :unique => true
      add_index :users , :lname
      add_index :users , :postcode
      add_index :users , :country 
  end

  def self.down
      remove_index :users , :username
      remove_index :users , :email
      remove_index :users , :lname
      remove_index :users , :postcode
      remove_index :users , :country    
  end
end
