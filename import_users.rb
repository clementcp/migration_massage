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
  g = User.find_or_create_by_key row["Email Address"]
  g.name = row["Full Name"]
  g.type = row["Role"]
  g.phone = row ["Phone"]
  g.save
  # puts g.inspect
  # puts g.id, g.name

  count +=1
  puts "Processing #{count} users ... " if count % 500 == 0
end

# Dump current User database
User.dump_storage
