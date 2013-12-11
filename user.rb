require 'yaml'
require 'set'

class User
  attr_reader :id, :required_agent, :groups_name, :type, :key, :twitter, :name, :organization
  attr_writer :type, :email, :name, :type, :phone, :required_agent
  def initialize key
    @key = key
    @type = 'end user'
    @groups_name = Set.new
    @required_agent = false


    if twitter?
      @twitter = key
      @email = @twitter[1..-1]+"@generic-twitter-user.com"
    else
      @email = key
    end
  end

  def save
    if !(self.class.find_by_key @key)
      @id = self.class.next_id
    end
    self.class.save_by_key self
  end

  def act_as_agent group_name
    @type = 'agent'
    @groups_name << group_name
  end

  def agent?
    @type == 'agent'
  end

  def twitter?
    # Save guard for @key being nil
    @key && @key[0]=='@'
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

  def self.find_by_key key
    self.storage[key]
  end

  def self.find_or_create_by_key key
    existed = self.find_by_key key
    return existed if existed

    newly_created = self.new key
    newly_created.save
    newly_created
  end

  def self.save_by_key u
    self.storage[u.key] = u
  end

  def self.next_id
    self.storage.length + 1
  end

  def self.default_agent
    default_agent = self.find_or_create_by_key 'Zendesk_default_agent'
    default_agent.act_as_agent 'General'
    default_agent.name = "Default Agent"
    default_agent.email = "defaultagent@test-for-medidata.com"
    default_agent.save
    default_agent
  end

  def self.default_user
    default_user = self.find_or_create_by_key "Zendesk_default_enduser"
    default_user.name = "Default User"
    default_user.email  = "defaultenduser@test-for-medidata.com"
    default_user.save
    default_user
  end

  def email
    @email.formatted_email
  end

  def type
    case @type.downcase
    when 'staff', 'half admin'
      return 'agent'
    when 'administrator'
      return 'admin'
    else
      return @type.downcase
    end
  end
end

class String
  def null_group?
    self.nil? || self.empty? || self.downcase=='null'
  end
end