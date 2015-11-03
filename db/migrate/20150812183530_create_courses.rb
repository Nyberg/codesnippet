class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.text :content
      t.integer :club_id
      t.integer :holes

      t.timestamps null: false
    end
  end
end
