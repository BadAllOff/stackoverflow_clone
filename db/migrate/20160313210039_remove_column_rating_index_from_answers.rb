class RemoveColumnRatingIndexFromAnswers < ActiveRecord::Migration
  def change
    remove_column :answers, :rating_index, :integer, default: 0
  end
end
