class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :user_id
      t.integer :round_id
      t.integer :tee_id
      t.integer :hole_id
      t.integer :score
      t.integer :ob
      t.integer :tour_part_id
      t.string :result
      t.integer :competition_id
      t.timestamps null: false
    end
  end
end
