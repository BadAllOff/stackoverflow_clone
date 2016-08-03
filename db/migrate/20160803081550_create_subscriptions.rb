class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.timestamps null: false
    end
    add_reference :subscriptions, :user, foreign_key: true
    add_reference :subscriptions, :question, foreign_key: true

    add_index :subscriptions, [:user_id, :question_id]
  end
end
