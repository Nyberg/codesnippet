class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :user_id
      t.integer :round_id
      t.integer :tee_id
      t.integer :hole_id
      t.integer :score

      t.timestamps null: false
    end
  end
end
