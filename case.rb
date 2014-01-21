require './storage.rb'


class Case
  extend Storage

  attr_reader :id, :subject, :group, :type, :status, :priority, :tags, :emailed_to, :userip, :webagent, :referrerURL, :webcookie, :threadid
  def initialize id, subject, description, create_date, closure_date, type, status, priority, tags, queue, emailed_to, userip, webagent, referrerURL, webcookie, threadid
    @id = id
    @subject = subject
    @description = description
    @create_date = create_date
    @closure_date = closure_date
    # @requester = requester
    # @group = group
    # @assignee = assignee
    @type = type
    @status = status
    @priority = priority
    @tags = tags
    @queue = queue
    @emailed_to = emailed_to
    @userip = userip
    @webagent = webagent
    @referrerURL = referrerURL
    @webcookie = webcookie
    @threadid = threadid
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


  def queue
    if !@queue.empty?
      return "legacy_queue_" + @queue.formatted_queue
    else
      return ""
    end
  end

  def create_date
    @create_date.formatted_time
  end

  def closure_date
    @closure_date.formatted_time
  end

  def description
    return "(empty)" if (@description.nil? | @description.empty?)
    @description
  end
end

