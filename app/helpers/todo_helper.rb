module TodoHelper
  def event_get_value(event, attribute, options = {})
    as = options[:as]

    v = event.send("get_#{attribute}")
    if v.blank?
      '不存在'
    elsif as == :datetime
      Time.zone.parse(v).to_s(:short_time)
    else
      v
    end
  end
end
