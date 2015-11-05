class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.number :club_id
      t.timestamps null: false
      t.integer :division
      t.integer :pdga
    end
  end
end
