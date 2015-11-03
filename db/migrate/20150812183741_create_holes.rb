class CreateHoles < ActiveRecord::Migration
  def change
    create_table :holes do |t|
      t.integer :course_id
      t.integer :number
      t.integer :par
      t.integer :length
      t.integer :tee_id

      t.timestamps null: false
    end
  end
end
