class Comment < ActiveRecord::Base
  include Eventable
  belongs_to :todo
  belongs_to :user

  after_create :gen_event
  def gen_event
    generate_event(user: self.user, target: self.todo, project: self.todo.project, action: :todo_commented,
                   after_value: body)
  end
end
