require './storage.rb'


class Case
  extend Storage

  attr_reader :id, :subject
  def initialize id, subject, description, created_at, resolved_at, type, status, priority, labels
    @id = id
    @subject = subject
    @description = description
    @created_at = created_at
    @resolved_at = resolved_at
    @type = type
    @status = status
    @priority = priority
    @labels = labels
  end

  def save
    self.class.save self
  end

  def closed?
    @status.downcase=='closed' || @status.downcase=='resolved'
  end

  def description
    return @subject if @description.empty?
    @description
  end

  def created_at
    @created_at.formatted_time
  end

  def resolved_at
    @resolved_at.formatted_time
  end

  def type
    "Problem"
  end

  def status
    return "Solved" if @status=="Resolved"
    @status
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
end

