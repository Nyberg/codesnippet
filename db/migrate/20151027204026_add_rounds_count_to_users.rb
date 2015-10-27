class AddRoundsCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rounds_count, :integer
  end
end
