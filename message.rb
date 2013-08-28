require './storage.rb'
require './case.rb'

class Message
  extend Storage

  attr_reader :id
  def initialize case_id, message_id, message, creation_date, author, is_public
    @case_id = case_id
    @id = message_id
    @body = message
    @created_at = creation_date
    @author = author
    @is_public = is_public
  end

  def public?
    @is_public
  end

  def case
    Case.find_by_id @case_id
  end

  def save
    self.class.save self
  end
end