class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.string :comp_name
      t.string :tour_name
      t.timestamp :date
      t.integer :club
      t.string :file

      t.timestamps null: false
    end
  end
end
