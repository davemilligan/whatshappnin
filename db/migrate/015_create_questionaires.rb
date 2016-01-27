##
# app/db/migrate/015_create_questionaires.rb
##
class CreateQuestionaires < ActiveRecord::Migration
  def self.up
    create_table :questionaires do |t|
      t.column :created_at, :datetime
      t.column :created_by, :integer
      t.column :responses, :integer, :default => 0
      t.column :activated, :boolean
      t.column :q1, :string,  :limit => 64
      t.column :q2, :string,  :limit => 64
      t.column :q3, :string,  :limit => 64
      t.column :q4, :string,  :limit => 64
      t.column :q5, :string,  :limit => 64
      t.column :q6, :string,  :limit => 64
      t.column :q7, :string,  :limit => 64
      t.column :q8, :string,  :limit => 64
      t.column :q9, :string,  :limit => 64
      t.column :q10, :string,  :limit => 64
    end
  end

  def self.down
    drop_table :questionaires
  end
end
