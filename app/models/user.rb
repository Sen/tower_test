class User < ActiveRecord::Base
  has_many :created_todos, class_name: 'Todo', foreign_key: :user_id, dependent: :nullify
  has_many :assigned_todos, class_name: 'Todo', foreign_key: :assignee_id, dependent: :nullify
end
