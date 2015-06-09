class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.text :content
      t.string :heading
      t.text :desc
      t.integer :user_id
      t.integer :category_id

      t.timestamps null: false
    end
  end
end
