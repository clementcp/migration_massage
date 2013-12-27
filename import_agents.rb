#!/usr/bin/env ruby
require 'csv'
require './user.rb'
require './string_extension.rb'

csv_filename = ARGV.shift
max = ARGV.shift.to_i
count = 0

# for medidata
# create an array of groups where the agents are "special"
# i.e. where their ticket matters
# listRequiredAgent = Array.new ["japan tier 2", "japan techincal services", "japan application support", "japan customer care", "doc japan", "doc apac", "doc ua", "doc tier 2"]

# Set up default support agent in case the agent was 'unassigned'
User.load_storage

CSV.foreach(csv_filename, :headers=>true) do |row|
  # limelight : agent's key = name downcase
  a = User.find_or_create_by_key row["Name"].downcase
  a.act_as_agent "General"
  a.name = row["Name"]
  if row["Email"].nil?
    # create a fake email address
    fakeEmail = row["Name"].gsub ' ', '.'
    a.email = fakeEmail + "@legacylimelightuser.com"
  else
    a.email = row["Email"]
  end

  # a.type = row["Role"]

  # check if the agent is of the special group!
  # if listRequiredAgent.include? row["Group"].downcase
  #   a.required_agent = true
  # end

  a.save
  # puts a.id, a.names

  count +=1
  # break if count >= 5000
  puts "Processing #{count} agents ... " if count % 100 == 0

end

puts "Processed #{count} agents in total!"

# Dump current User database
User.dump_storage
