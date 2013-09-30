require './storage.rb'


class Case
  extend Storage

  # attr_reader :id, :subject
  # def initialize id, subject, description, created_at, resolved_at, type, status, priority, labels
  #   @id = id
  #   @subject = subject
  #   @description = description
  #   @created_at = created_at
  #   @resolved_at = resolved_at
  #   @type = type
  #   @status = status
  #   @priority = priority
  #   @labels = labels
  # end

  attr_reader :id, :description
  def initialize id, room_number, serial_number, client_id, client_email, location_id, description, resolution, category_id, open_date, close_date, assigned_to, last_name_assigned_to, group, state
    @id = id
    @room_number = room_number
    @serial_number = serial_number
    @client_id = client_id
    @client_email =client_email
    @location_id = location_id
    @description = description
    @resolution = resolution
    @category_id = category_id
    @open_date = open_date
    @close_date = close_date
    @assigned_to = assigned_to
    @last_name_assigned_to = last_name_assigned_to
    @group = group
    @state = state
  end

  def save
    self.class.save self
  end

  def closed?
    @state.downcase=="c"
  end

  def subject
    return "Legacy ticket - " + @category_id
  end


  def created_at
    @open_date.formatted_time
  end

  def resolved_at
    if @state.downcase=="c"
      return @close_date.formatted_time
    end
    ""
  end

  def type
    "Incident"
  end

  def status
    return "Closed" if @state=="C"
    "Open"
  end

  def priority
    "Normal"
  end

  def tags
    # space => underscore, semicolon => space
    out = @labels.gsub " ", "_"
    out = out.gsub ";", " "
    # adding "type" as tag
    out << " #{@type.downcase}"
    out
  end

  def v_serial_number
    return @serial_number if (@serial_number && @serial_number[0].downcase=="v")
    ""
  end

  def r_serial_number
    return @serial_number if (@serial_number && @serial_number[0].downcase=="r")
    ""
  end

  def sb_serial_number
    return @serial_number if (@serial_number && @serial_number[0..1].downcase=="sb")
    ""
  end

  def group
    # DIS APPLICATION SUPPORT -->     SIS Group
    # DIS ERP CRC -->       Business Apps Group
    # DIS ERP MCPEC -->     ERP Group
    # DIS EXCEPTIONAL STUDENTS -->    SIS Group
    # DIS INSTRUCTIONAL TECHNOLOGY -->  ITS Group
    # DIS MAINFRAME -->     Business Apps Group
    # DIS PORTAL AND WEB -->      SharePoint\Web Group
    case @group
      when "DIS APPLICATION SUPPORT", "DIS EXCEPTIONAL STUDENTS"
        return "SIS Group"
      when "DIS ERP CRC", "DIS MAINFRAME"
        return "Business Apps Group"
      when "DIS ERP MCPEC"
        return "ERP Group"
      when "DIS INSTRUCTIONAL TECHNOLOGY"
        return "ITS Group"
      when "DIS PORTAL AND WEB"
        return "SharePoint/Web Group"
      else
        puts "no mapping for "+ @group
        return @group
      end
  end
end

