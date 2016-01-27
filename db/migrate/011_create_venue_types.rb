##
# app/db/migrate/011_create_venue_types.rb
##
class CreateVenueTypes < ActiveRecord::Migration
  def self.up
    create_table :venue_types do |t|
      t.column :category, :string, :null => false
      t.column :english, :string
    end
    
    VenueType.reset_column_information
    VenueType.create(:category => 'bar', :english => 'bar')
    VenueType.create(:category => 'cafe-bar', :english => 'cafe-bar')
    VenueType.create(:category => 'restaurant', :english => 'restaurant')
    VenueType.create(:category => 'nightclub', :english => 'nightclub')
    VenueType.create(:category => 'theatre', :english => 'theatre')
    VenueType.create(:category => 'cinema', :english => 'cinema')
    VenueType.create(:category => 'outdoor', :english => 'outdoor')
    VenueType.create(:category => 'hotel', :english => 'hotel')
    VenueType.create(:category => 'guest-house', :english => 'guest-house')
    VenueType.create(:category => 'leisure', :english => 'leisurer')
    VenueType.create(:category => 'other', :english => 'other')
  
  end


   
  def self.down
    drop_table :venue_types
  end
end