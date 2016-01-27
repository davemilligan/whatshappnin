##
# app/db/migrate/016_create_questionaires_answers.rb
##
class CreateQuestionaireAnswers < ActiveRecord::Migration
  def self.up
    create_table :questionaire_answers do |t|
      t.column :created_at, :datetime
      t.column :user_id, :integer      
      t.column :quest_id, :integer
      t.column :q1, :boolean,  :default => false
      t.column :q2, :boolean,  :default => false
      t.column :q3, :boolean,  :default => false
      t.column :q4, :boolean,  :default => false
      t.column :q5, :boolean,  :default => false
      t.column :q6, :boolean,  :default => false
      t.column :q7, :boolean,  :default => false
      t.column :q8, :boolean,  :default => false
      t.column :q9, :boolean,  :default => false
      t.column :q10, :boolean,  :default => false
      t.column :comments, :text,  :limit => 5000
      
    end
  end

  def self.down
    drop_table :questionaire_answers
  end
end
