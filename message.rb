require './storage.rb'
require './case.rb'
require './string_extension.rb'

class Message
  extend Storage

  attr_reader :case_id, :id, :body
  def initialize case_id, creation_date, author, body, id
    @case_id = case_id
    @creation_date = creation_date
    @author = author
    @body = body
    @id = id
    @is_public = true
  end

  def public?
    # @is_public.downcase == 'y'
    return false if @is_public.downcase == 'false'
    true
  end

  # def formatted_public
  #   return 'TRUE' if public?
  #   'FALSE'
  # end

  # def case_id
  #   @case_id.formatted_id
  # end

  def created_at
    @creation_date.formatted_time_comment
  end

  def case
    Case.find_by_id @case_id
  end

  def save
    self.class.save self
  end
end