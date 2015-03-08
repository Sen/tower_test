class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.text :body
      t.string :aasm_state
      t.integer :user_id
      t.integer :project_id
      t.integer :assignee_id
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :todos, :user_id
    add_index :todos, :project_id
    add_index :todos, :assignee_id
  end
end
