require 'yaml'
require 'set'

class User
  attr_reader :id, :groups_name, :type, :key, :name, :phone, :email
  attr_writer :type, :email, :name, :type, :phone
  def initialize key
    @key = key
    @type = 'end user'
    @groups_name = Set.new
    @required_agent = false


    # if twitter?
    #   @twitter = key
    #   @email = @twitter[1..-1]+"@generic-twitter-user.com"
    # else
    #   @email = key
    # end
    @email = key

  end

  def save
    if !(self.class.find_by_key @key)
      @id = self.class.next_id
    end
    self.class.save_by_key self
    self.class.update_index self
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

  def self.storage_by_name
    @@storage_by_name ||= Hash.new
  end

  def self.load_storage yaml='./user.yaml'
    user_file = File.open(yaml, 'r')
    @@storage = YAML.load user_file
    self.index_by_name
  rescue
    # Ignore any exception which is likely to be non existed file
  end

  def self.dump_storage yaml='./user.yaml'
    serialized = YAML.dump User.storage
    user_file = File.open(yaml, 'wb')
    user_file.write(serialized)
  end

  def self.index_by_name
    self.storage.each_pair do |key, user|
      self.update_index user
    end
  end

  def self.update_index user
    self.storage_by_name[user.name] = user
  end

  def self.find_by_name name
    self.storage_by_name[name]
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
    default_agent = self.find_or_create_by_key 'defaultagent@migrationtest-for-limelight.com'
    default_agent.act_as_agent 'General'
    default_agent.name = "Default Agent"
    default_agent.save
    default_agent
  end

  def self.default_commenter
    default_agent = self.find_or_create_by_key 'defaultcommenter@migrationtest-for-limelight.com'
    default_agent.act_as_agent 'General'
    default_agent.name = "Default Commenter"
    default_agent.save
    default_agent
  end

  def self.default_user
    default_user = self.find_or_create_by_key "defaultenduser@migrationtest-for-limelight.com"
    default_user.name = "Default User"
    default_user.save
    default_user
  end

  # def email
  #   @email.formatted_email
  # end

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

  # def self.find_by_name name
  #   self.load_storage
  #   self.storage.each do |key|
  #     puts "aa debug : key = ", key
  #     puts "aa debug2 : self.storage[key] = ", self.storage[key].to_s
  #     # if storage[key].name == name
  #     #   return key
  #     # else
  #     #   return false
  #     # end
  #   end
  # end

end

class String
  def null_group?
    self.nil? || self.empty? || self.downcase=='null'
  end
end