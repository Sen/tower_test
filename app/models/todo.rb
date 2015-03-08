class Todo < ActiveRecord::Base
  acts_as_paranoid
  include Eventable
  include AASM

  belongs_to :user
  belongs_to :assignee, class_name: 'User', foreign_key: :assignee_id
  belongs_to :project
  has_many :comments

  aasm do
    state :pending, :initial => true
    state :complete

    event :archive do
      transitions from: :pending, to: :complete, after: Proc.new {|*args| gen_complete_event(*args) }
    end
  end

  def assign_user(a_user, operator)
    # TODO transaction
    old_assignee = self.assignee
    action = \
      if old_assignee != a_user && old_assignee.present?
        :todo_assignee_changed
      else
        :todo_assigned
      end

    update_attribute(:assignee, a_user)
    generate_event(user: operator, target: self, project: self.project, action: action,
                   before_value: old_assignee, after_value: a_user)
  end

  def gen_destroy_event(a_user)
    # TODO operator
    generate_event(user: a_user, target: self, project: self.project, action: :todo_destroied)
  end

  def change_due_date(time, a_user)
    before_value = self.due_date.try(:to_s)
    update_attribute(:due_date, time)
    after_value = self.due_date.try(:to_s)

    generate_event(user: a_user, target: self, project: self.project, action: :todo_due_date_changed,
                   before_value: before_value, after_value: after_value)
  end

  private

  def gen_complete_event(user)
    generate_event(user: user, target: self, project: self.project, action: :todo_complete)
  end

  after_create :gen_create_event
  def gen_create_event
    generate_event(user: self.user, target: self, project: self.project, action: :todo_created)
  end
end
