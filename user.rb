class User
  attr_reader :id, :email, :group_name
  def initialize email
    @email = email
    @type = 'user'
  end

  def save
    if !(self.class.find_by_email @email)
      self.class.save_by_email self
      @id = self.class.next_id
    end
  end

  def act_as_agent group_name
    @type = 'agent'
    @group_name = group_name
  end

  def agent?
    @type == 'agent'
  end

  def self.storage
    @@storage ||= Hash.new
  end

  def self.find_by_email email
    self.storage[email]
  end

  def self.find_or_create_by_email email
    existed = self.find_by_email email
    return existed if existed

    newly_created = self.new email
    newly_created.save
    newly_created
  end

  def self.save_by_email u
    self.storage[u.email] = u
  end

  def self.next_id
    @@id ||= 0
    @@id += 1
  end
end