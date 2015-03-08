require 'rails_helper'

RSpec.describe EventsController, :type => :controller do
  render_views

  def generate_data
    jim       = FactoryGirl.create(:user, name: 'jim')
    tom       = FactoryGirl.create(:user, name: 'tom')
    sam       = FactoryGirl.create(:user, name: 'sam')

    team      = FactoryGirl.create(:team, name: 'test team')
    project_1 = FactoryGirl.create(:project, name: 'test project 1', user: jim, team: team)
    project_2 = FactoryGirl.create(:project, name: 'test project 2', user: jim, team: team)

    todo_1    = FactoryGirl.create(:todo, body: 'todo_1', user: jim, project: project_1)
    todo_2    = FactoryGirl.create(:todo, body: 'todo_2', user: jim, project: project_1)

    todo_3    = FactoryGirl.create(:todo, body: 'todo_3', user: jim, project: project_2)
    todo_4    = FactoryGirl.create(:todo, body: 'todo_4', user: jim, project: project_2)
    todo_5    = FactoryGirl.create(:todo, body: 'todo_5', user: jim, project: project_2)

    todo_1.archive!(tom)

    todo_2.destroy
    todo_2.gen_destroy_event(sam)

    todo_3.assign_user(tom, jim)
    todo_3.assign_user(sam, jim)

    todo_4.change_due_date(3.days.since, jim)
    todo_4.change_due_date(5.days.since, tom)

    todo_5.comments.create(body: 'test comment', user: tom)
  end

  it 'index' do
    generate_data

    get :index

    expect(response).to be_success
    expect(response).to render_template(:index)
    expect(response).to render_template(:_todo_due_date_changed)
    expect(response).to render_template(:_todo_assigned)
    expect(response).to render_template(:_todo_assignee_changed)
    expect(response).to render_template(:_todo_commented)
    expect(response).to render_template(:_todo_complete)
    expect(response).to render_template(:_todo_created)
    expect(response).to render_template(:_todo_destroied)
  end
end
