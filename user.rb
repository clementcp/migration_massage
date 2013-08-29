require 'yaml'

class User
  attr_reader :id, :email, :group_name
  def initialize email
    @email = email
    @type = 'user'
  end

  def save
    if !(self.class.find_by_email @email)
      @id = self.class.next_id
      self.class.save_by_email self
    end
  end

  def act_as_agent group_name
    @type = 'agent'
    @group_name = group_name
  end

  def agent?
    @type == 'agent'
  end

  def twitter?
    @email[0]=='@'
  end

  def self.storage
    @@storage ||= Hash.new
  end

  def self.load_storage yaml='./user.yaml'
    user_file = File.open(yaml, 'r')
    @@storage = YAML.load user_file
  rescue
    # Ignore any exception which is likely to be non existed file
  end

  def self.dump_storage yaml='./user.yaml'
    serialized = YAML.dump User.storage
    user_file = File.open(yaml, 'wb')
    user_file.write(serialized)
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
    self.storage.length + 1
  end
end