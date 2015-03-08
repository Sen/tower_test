class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :todo_id
      t.text :body
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :comments, :todo_id
    add_index :comments, :user_id
  end
end
