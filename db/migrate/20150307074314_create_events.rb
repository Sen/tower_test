class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :user_id
      t.string :target_type
      t.integer :target_id
      t.integer :project_id
      t.string :action

      t.string :before_value
      t.string :after_value

      t.timestamps null: false
    end
    add_index :events, :user_id
    add_index :events, :target_type
    add_index :events, :target_id
    add_index :events, :project_id
    add_index :events, :action
  end
end
