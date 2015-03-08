module Eventable
  extend ActiveSupport::Concern

  def generate_event(options)
    user    = options.fetch(:user)
    target  = options.fetch(:target)
    action  = options.fetch(:action)
    project = options.fetch(:project)

    before_value = options.fetch(:before_value, nil)
    after_value = options.fetch(:after_value, nil)

    Event.create!(user: user, target: target, action: action, project: project,
                  before_value: encode_value(before_value), after_value: encode_value(after_value))
  end

  def encode_value(value)
    return if value.blank?
    if value.is_a?(String)
      value
    elsif value.is_a?(ActiveRecord::Base)
      "model: #{value.class.name}(#{value.id})"
    else
      raise "encode value: #{value} not supported yet"
    end
  end

end
