class CreateTourParts < ActiveRecord::Migration
  def change
    create_table :tour_parts do |t|
      t.string :name
      t.text :content
      t.integer :course_id
      t.integer :competition_id
      t.integer :tee_id

      t.timestamps null: false
    end
  end
end
