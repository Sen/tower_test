class EventsController < ApplicationController
  def index
    # TODO N+1

    @events = Event.order('created_at DESC')
  end
end
