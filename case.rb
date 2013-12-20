require './storage.rb'


class Case
  extend Storage

  attr_reader :id, :subject, :priority, :tags
  def initialize id, subject, description, creation_date, closure_date, type, status, priority, tags
    @id = id
    @subject = subject
    @description = description
    @creation_date = creation_date
    @closure_date = closure_date
    @type = type
    @status = status
    @priority = priority
    @tags = tags
  end

  def save
    self.class.save self
  end

  def status
    @status.downcase
  end

  # def closed?
  #   @status.downcase == 'closed'
  # end

  def solved?
    @status.downcase == 'solved'
  end

  def created_date
    @creation_date.formatted_time
  end

  def closure_date
    return @closure_date.formatted_time if self.solved?
    ''
  end

  def type
    "Incident"
  end

  def priority
    if @priority.downcase == 'medium'
      return 'normal'
    end
    @priority.downcase
  end

  def description
    if @description.nil?
      return "(empty)"
    else
      if @description.empty?
        return "(empty)"
      else
        return @description
      end
    end
  end

end

