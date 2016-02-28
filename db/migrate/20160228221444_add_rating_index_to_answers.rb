class AddRatingIndexToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :rating_index, :integer, default: 0
  end
end
