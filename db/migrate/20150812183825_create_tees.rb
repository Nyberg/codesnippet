class CreateTees < ActiveRecord::Migration
  def change
    create_table :tees do |t|
      t.string :color
      t.integer :course_id
      t.integer :par
      t.timestamps null: false
    end
  end
end
