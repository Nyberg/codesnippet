class CreateCompetitions < ActiveRecord::Migration
  def change
    create_table :competitions do |t|
      t.string :name
      t.string :title
      t.text :content
      t.integer :club_id
      t.timestamp :date
      t.timestamps null: false
    end
  end
end
