require './storage.rb'

class Case
  extend Storage

  attr_reader :id
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
end

