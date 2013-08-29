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

  def type
    return "end user" if @type == "user"
    @type
  end

  def act_as_agent group_name
    @type = 'agent'
    @group_name = group_name unless group_name.null_group?
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

  def self.default_agent
    default_agent = self.find_or_create_by_email 'zoelle@crocodoc.com'
    default_agent.act_as_agent 'General'
    default_agent.save
    default_agent
  end

  def self.default_user
    self.find_or_create_by_email 'dummy_user@test_for_box.earth'
  end
end

class String
  def null_group?
    self.nil? || self.empty? || self.downcase=='null'
  end
end