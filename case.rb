require './storage.rb'


class Case
  extend Storage

  attr_reader :tags, :old_ticket_id, :area, :sub_area, :sub_sub_area, :resolution, :comments
  def initialize old_ticket_id, status, urgency, created_date, resolved_date, closed_date, sponsor, study, area, sub_area, sub_sub_area, description, resolution, updated, overall_score_and_description, comments
    @old_ticket_id = old_ticket_id
    @status = status
    @urgency = urgency
    @created_date = created_date
    @resolved_date = resolved_date
    @closed_date = closed_date
    @sponsor = sponsor
    @study = study
    @area = area
    @sub_area = sub_area
    @sub_sub_area = sub_sub_area
    @description = description
    @resolution = resolution
    @updated = updated
    @overall_score_and_description = overall_score_and_description
    @comments = comments
  end

  # attr_reader :id, :room_number, :resolution
  # def initialize id, room_number, serial_number, client_id, client_email, location_id, description, resolution, category_id, open_date, close_date, assigned_to, last_name_assigned_to, group, state
  #   @id = id
  #   @room_number = room_number
  #   @serial_number = serial_number
  #   @client_id = client_id
  #   @client_email =client_email
  #   @location_id = location_id
  #   @description = description
  #   @resolution = resolution
  #   @category_id = category_id
  #   @open_date = open_date
  #   @close_date = close_date
  #   @assigned_to = assigned_to
  #   @last_name_assigned_to = last_name_assigned_to
  #   @group = group
  #   @state = state
  # end

  def save
    self.class.save self
  end

  def closed?
    @status.downcase=="closed"
  end

  # def subject
  #   return "Legacy ticket - " + @category_id
  # end

  # def description
  #   return @category_id if @description.nil?
  #   @description
  # end

  # def created_at
  #   @open_date.formatted_time
  # end

  # def comment_created_at
  #   # if @close_date.empty?
  #   if @close_date.nil?
  #     return @open_date.formatted_time
  #   end
  #   @close_date.formatted_time
  # end

  # def resolved_at
  #   if self.closed?
  #     if !@close_date.nil?
  #       return @close_date.formatted_time
  #     else
  #       return @open_date.formatted_time
  #     end
  #   end
  #   ""
  # end

  # def status
  #   return "Closed" if self.closed?
  #   "Open"
  # end


  # def queue
  #   if !@queue.empty?
  #     return "legacy_queue_" + @queue.formatted_queue
  #   else
  #     return ""
  #   end
  # end

  # def create_date
  #   @create_date.formatted_time
  # end

  # def closure_date
  #   @closure_date.formatted_time
  # end

  def id
    # puts @old_ticket_id.formatted_id
    @old_ticket_id.formatted_id
  end

  def description
    return '(empty)' if (@description.nil? | @description.empty?)
    @description
  end

  def created_date
    @created_date.formatted_time
  end

  def closure_date
    return @closed_date.formatted_time if self.closed?
    @resolved_date.formatted_time
  end

  def type
    "Incident"
  end

  def status
    return 'solved' if (@status.downcase == 'delete' or @status.downcase == 'resolved')
    @status.downcase
  end

  def priority
  #low normal high urgent
    if !@urgency.nil?
      case @urgency.downcase
      when 'medium'
        return 'normal'
      when 'cirt'
        return 'urgent'
      else
        return @urgency.downcase
      end
    else
      return ''
    end
  end

  def urgency
    if !@urgency.nil?
      case @urgency.downcase
      when 'low'
        return 'low_urgency'
      when 'medium'
        return 'medium_urgency'
      when 'high'
        return 'high_urgency'
      when 'cirt'
        return 'cirt_urgency'
      else
        return 'medium_urgency'
      end
    else
      return ''
    end
  end

  def sponsor_study
    return @sponsor + ' ' + @study
  end

  def overall_score_and_description
    if @overall_score_and_description.nil?
      @overall_score_and_description
    else
      case @overall_score_and_description.downcase
      when 'yes'
        return 'good'
      when 'no'
        return 'bad'
      else
        return 'unoffered'
      end
    end
  end

end

