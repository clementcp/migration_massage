require './storage.rb'
require './case.rb'
require './string_extension.rb'

class Message
  extend Storage

  attr_reader :id, :case_id, :body, :author
  def initialize case_id, creation_date, author, message, message_id
    @case_id = ar_number
    @creation_date = act_created
    @author = act_owner
    @message = act_desc
    @message_id = act_number
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

  def created_at
    @createdion_date.formatted_time_comment
  end

  def case
    Case.find_by_id @case_id
  end

  def save
    self.class.save self
  end
end