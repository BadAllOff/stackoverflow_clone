class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.string :commentable_type
      t.integer :commentable_id

      t.timestamps null: false
    end

    add_index :comments, [:commentable_type, :commentable_id]
  end
end
