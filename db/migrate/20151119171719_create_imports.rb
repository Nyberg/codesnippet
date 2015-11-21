class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.string :comp_name
      t.string :tour_name
      t.integer :course
      t.integer :tee
      t.timestamp :date
      t.integer :club
      t.string :import_sheet

      t.timestamps null: false
    end
  end
end
