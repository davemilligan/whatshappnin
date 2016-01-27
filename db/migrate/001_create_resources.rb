##
# app/db/migrate/001_create_resources.rb
##
class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      t.column :name, :string, :null => false
      t.column :value, :text
    end
    Resource.reset_column_information
    Resource.create(:name => 'dave', :value => '')
    Resource.create(:name => 'google_maps_api_key', 
                    :value => 'ABQIAAAAZdLJ0UjM_lpriGtqQ62SWRTIZn48QkjjLmUYaM'\
                              'hPwRLpSf5RPBQcB02pmEte0hQaqusA2PCdD-qc1A')
    Resource.create(:name => 'venue_max_image_size', :value => '102400')
    Resource.create(:name => 'resources_paginator_count', :value => '20')
  end

  def self.down
    drop_table :resources
  end
end
