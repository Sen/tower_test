require 'rails_helper'

RSpec.describe Todo, :type => :model do
  let(:todo) { create(:todo) }
  let(:jim) { create(:user, name: 'jim') }

  it 'create todo will generate event' do
    events_count = Event.count
    create(:todo)

    expect(Event.count).to eq(events_count + 1)
    event = Event.last
    expect(event.project).to be_present
  end

  it 'archive todo will generate event' do
    todo
    events_count = Event.count
    todo.archive!(jim)
    expect(todo.complete?).to eq(true)

    expect(Event.count).to eq(events_count + 1)
    expect(Event.last.action).to eq('todo_complete')
  end

  it 'destroy todo will generate event' do
    todo
    events_count = Event.count
    todo.destroy
    todo.gen_destroy_event(jim)

    expect(Event.count).to eq(events_count + 1)
    expect(Event.last.action).to eq('todo_destroied')
  end

  it 'assign user will generate events' do
    todo
    events_count = Event.count
    sam = create(:user, name: 'sam')
    tom = create(:user, name: 'tom')

    todo.assign_user(jim, sam)

    expect(todo.assignee).to eq(jim)
    expect(Event.count).to eq(events_count + 1)
    expect(Event.last.action).to eq('todo_assigned')

    todo.assign_user(tom, sam)
    expect(todo.assignee).to eq(tom)
    expect(Event.count).to eq(events_count + 2)
    expect(Event.last.action).to eq('todo_assignee_changed')
  end

  it 'change due date will generate event' do
    todo
    events_count = Event.count
    todo.change_due_date(3.days.since, jim)

    expect(Event.count).to eq(events_count + 1)
    expect(Event.last.action).to eq('todo_due_date_changed')

    tom = create(:user, name: 'tom')
    todo.change_due_date(5.days.since, tom)

    expect(Event.count).to eq(events_count + 2)
    expect(Event.last.action).to eq('todo_due_date_changed')
  end

  it 'comment todo will generate event' do
    todo
    events_count = Event.count
    todo.comments.create(body: 'test', user: jim)

    expect(Event.count).to eq(events_count + 1)
    expect(Event.last.action).to eq('todo_commented')
  end
end
