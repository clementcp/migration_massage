#!/usr/bin/env ruby
require 'csv'
require './user.rb'
require './string_extension.rb'

csv_filename = ARGV.shift
max = ARGV.shift.to_i
count = 0

# Set up default support agent in case the agent was 'unassigned'
User.load_storage

CSV.foreach(csv_filename, :headers=>true) do |row|
  a = User.find_or_create_by_key row["External ID"]
  a.type = "agent"
  a.name = row["Name"]
  a.email = row["Email"]
  a.organization = row["Organization"]
  a.save
 # puts a.id, a.name
end

# Dump current User database
User.dump_storage
