require './user.rb'

class Agent < User
  attr_reader :group_name
  def initialize email, group_name
    super email
    @group_name = group_name
  end
end