require './storage.rb'
require './case.rb'
require './string_extension.rb'

class Message
  extend Storage

  attr_reader :id, :case_id, :body, :author
  def initialize case_id, message_id, message, creation_date, is_public
    @case_id = case_id
    @id = message_id
    @body = message
    @created_at = creation_date
    # @author = author
    @is_public = is_public
  end

  def public?
    # @is_public.downcase == 'y'
    return false if @is_public.downcase == 'false'
    true
  end

  def formatted_public
    return 'TRUE' if public?
    'FALSE'
  end

  def created_at
    @created_at.formatted_time
  end

  def case
    Case.find_by_id @case_id
  end

  def save
    self.class.save self
  end
end