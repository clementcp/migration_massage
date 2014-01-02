require './storage.rb'
require './case.rb'
require './string_extension.rb'

class Message
  extend Storage

  attr_reader :id, :case_id, :body, :is_public
  def initialize id, case_id, is_public, creation_date, body
    @id = id
    @case_id = case_id
    @is_public = is_public
    @creation_date = creation_date
    @body = body
    @id = id
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
    @creation_date.formatted_comment_time
  end

  # def case
  #   Case.find_by_id @case_id
  # end

  def save
    self.class.save self
  end
end