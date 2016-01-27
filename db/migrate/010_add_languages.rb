##
## app/db/migrate/010_add_languages.rb
##
class AddLanguages < ActiveRecord::Migration
  def self.up
     add_column :resources,:english, :text
     add_column :resources,:spanish, :text
     add_column :resources,:french, :text
     add_column :resources,:german, :text
     add_column :resources,:italian, :text
  end

  def self.down
    remove_column :resources, :english
    remove_column :resources, :spanish
    remove_column :resources, :french
    remove_column :resources, :german
    remove_column :resources, :italian
  end
end
