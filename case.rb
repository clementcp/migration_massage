require './storage.rb'


class Case
  extend Storage

  attr_reader :id, :subject, :description, :case_owner, :case_comments
  def initialize case_owner, id, priority, subject, description, case_comments, date_opened, date_closed, status_open, status_closed, account_name
    @case_owner = case_owner
    @id = id
    @priority = priority
    @subject = subject
    @description = description
    @case_comments = case_comments
    @date_opened = date_opened
    @date_closed = date_closed
    @status_open = status_open
    @status_closed = status_closed
    @account_name = account_name
  end

  def save
    self.class.save self
  end

  def status
    return 'open' if @status_open == 1
    return 'closed' if @status_closed == 1
    return 'ERROR'
  end

  def closed?
    @status_closed == 1
  end

  def created_date
    @date_opened.formatted_time
  end

  def closure_date
    @date_closed.formatted_time if self.closed?
    ''
  end

  def type
    "Incident"
  end

  def priority
  #low normal high urgent
    case @priority.downcase
    when 'urgent!'
      return 'urgent'
    when 'p1'
      return 'urgent'
    when 'p2'
      return 'high'
    when 'p3'
      return 'medium'
    when 'p4'
      return 'low'
    else
      return @priority.downcase
    end
  end

end

