class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :team_id
      t.string :name
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :projects, :team_id
    add_index :projects, :user_id
  end
end
