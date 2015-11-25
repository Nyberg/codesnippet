class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.integer :user_id
      t.integer :course_id
      t.integer :competition_id
      t.integer :tee_id
      t.integer :tour_part_id
      t.integer :total
      t.integer :division_id
      t.integer :place
      t.integer :points
      t.timestamps null: false
    end
  end
end
