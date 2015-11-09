class AddResultIdScores < ActiveRecord::Migration
  def change
    add_column :scores, :result_id, :integer
  end
end
