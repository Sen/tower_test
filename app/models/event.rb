class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  belongs_to :target, -> { with_deleted }, polymorphic: true

  def get_before_value
    decode_value(self.before_value)
  end

  def get_after_value
    decode_value(self.after_value)
  end

  private

  def decode_value(value)
    if /^model: (\w+)\((\d+)\)/ =~ value
      $1.constantize.find($2)
    else
      value
    end
  end
end
