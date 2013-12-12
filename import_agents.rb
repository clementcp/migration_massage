#!/usr/bin/env ruby
require 'csv'
require './user.rb'
require './string_extension.rb'

csv_filename = ARGV.shift
max = ARGV.shift.to_i
count = 0

# create an array of groups where the agents are "special"
# i.e. where their ticket matters
listRequiredAgent = Array.new ["japan tier 2", "japan techincal services", "japan application support", "japan customer care", "doc japan", "doc apac", "doc ua", "doc tier 2"]

# Set up default support agent in case the agent was 'unassigned'
User.load_storage

CSV.foreach(csv_filename, :headers=>true) do |row|
  a = User.find_or_create_by_key row["Name"].downcase
  a.act_as_agent row["Group"]
  a.name = row["Name"]
  a.email = row["Email"]
  a.type = row["Role"]

  # check if the agent is of the special group!
  if listRequiredAgent.include? row["Group"].downcase
    a.required_agent = true
  end

  a.save
  # puts a.id, a.names

  count +=1
  # break if count >= 5000
  puts "Processing #{count} users ... " if count % 100 == 0

end

puts "Processed #{count} users in total!"

# Dump current User database
User.dump_storage
