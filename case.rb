require './storage.rb'


class Case
  extend Storage

  attr_reader :id, :subject, :description, :create_date, :closure_date, :requester, :group, :assignee, :type, :status, :priority, :tags, :queue, :emailed_to, :userip, :webagent, :referrerURL, :webcookie, :threadid
  def initialize id, subject, description, create_date, closure_date, requester, group, assignee, type, status, priority, tags, queue, emailed_to, userip, webagent, referrerURL, webcookie, threadid
    @id = id
    @subject = subject
    @description = description
    @create_date = create_date
    @closure_date = closure_date
    @requester = requester
    @group = group
    @assignee = assignee
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

  # def closed?
  #   @state.downcase=="c"
  # end

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

  # def type
  #   "Incident"
  # end

  # def status
  #   return "Closed" if self.closed?
  #   "Open"
  # end

  # def priority
  #   "Normal"
  # end

  # def tags
  #   # # space => underscore, semicolon => space
  #   # out = @labels.gsub " ", "_"
  #   # out = out.gsub ";", " "
  #   # # adding "type" as tag
  #   # out << " #{@type.downcase}"
  #   # out
  # end

  # def v_serial_number
  #   if @serial_number.nil?
  #     return ""
  #   else
  #     if @serial_number[0].nil?
  #       return ""
  #     else
  #       return @serial_number if (!!@serial_number && @serial_number[0].downcase=="v")
  #     end
  #   end
  # end

  # def r_serial_number
  #   if @serial_number.nil?
  #     return ""
  #   else
  #     if @serial_number[0].nil?
  #       return ""
  #     else
  #       return @serial_number if (!!@serial_number && @serial_number[0].downcase=="m")
  #     end
  #   end
  # end

  # def sb_serial_number
  #   if @serial_number.nil?
  #     return ""
  #   else
  #     if @serial_number[0].nil?
  #       return ""
  #     else
  #       return @serial_number if (!!@serial_number && @serial_number[0..1].downcase=="sb")
  #     end
  #   end
  # end

  # def group
  #   # DIS APPLICATION SUPPORT         SIS
  #   # DIS CUSTOMER SUPPORT            Customer Support Center
  #   # DIS DATA CENTER                 Data Center
  #   # DIS ERP CRC                     Business Apps
  #   # DIS ERP MCPEC                   ERP
  #   # DIS EXCEPTIONAL STUDENTS        SIS
  #   # DIS FISCAL SERVICES             Fiscal Services
  #   # DIS INSTRUCTIONAL TECHNOLOGY    ITS
  #   # DIS MAINFRAME                   Business Apps
  #   # DIS MANAGEMENT                  Customer Support Center
  #   # DIS PORTAL AND WEB              SharePoint/Web Group
  #   # DIS SCHOOL NUTRITION            TBD
  #   # DIS TECHNICAL SUPPORT           Technical Support
  #   # PS DISPATCH
  #   # PS ZONE EROSION CONTROL
  #   # SYSTEM ADMINSTRATION            Customer Support Center
  #   case @group
  #     when "DIS APPLICATION SUPPORT", "DIS EXCEPTIONAL STUDENTS"
  #       return "SIS"
  #     when "DIS CUSTOMER SUPPORT", "DIS MANAGEMENT", "SYSTEM ADMINISTRATION"
  #       return "Customer Support Center"
  #     when "DIS DATA CENTER"
  #       return "Data Center"
  #     when "DIS ERP CRC", "DIS MAINFRAME"
  #       return "Business Apps"
  #     when "DIS ERP MCPEC"
  #       return "ERP"
  #     when "DIS FISCAL SERVICES"
  #       return "Fiscal Services"
  #     when "DIS INSTRUCTIONAL TECHNOLOGY"
  #       return "ITS"
  #     when "DIS PORTAL AND WEB"
  #       return "SharePoint/Web Group"
  #     when "DIS SCHOOL NUTRITION"
  #       return "TBD"
  #     when "DIS TECHNICAL SUPPORT"
  #       return "Technical Support"
  #     else
  #       # puts "DEBUG -- no mapping for "+ @group
  #       return @group
  #     end
  # end
end

