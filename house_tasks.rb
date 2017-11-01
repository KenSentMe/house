module Tasks
  def alter_description(affected_object, altered_description)
    affected_object.description = altered_description
    @reply_text = altered_description
  end

  def change_visibility(affected_object, visibility_state)
    affected_object.visible = visibility_state
  end

  def change_pickup(affected_object, pickup_state)
    affected_object.pickup = pickup_state
  end

  def run_job(job)
    job.each do |j|
      case j[:job]
      when "alter_description"
        affected_object = j[:affected_object]
        altered_description = j[:altered_description]
        alter_description(affected_object, altered_description)
      when "change_visibility"
        affected_object = j[:affected_object]
        visibility_state = j[:visibility_state]
        change_visibility(affected_object, visibility_state)
      when "change_pickup"
        affected_object = j[:affected_object]
        pickup_state = j[:pickup_state]
        change_pickup(affected_object, pickup_state)
      end
    end
  end
end