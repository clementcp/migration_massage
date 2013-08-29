#!/usr/bin/env ruby

require 'csv'
require './case.rb'
require './user.rb'
require './message.rb'

csv_filename = ARGV.shift
max = ARGV.shift.to_i
count = 0

CSV.foreach(csv_filename, :headers=>true, :header_converters=>:symbol) do |row|
  c = Case.new row[:case_id], row[:subject], row[:description], row[:created_at], row[:resolved_at], row[:type], row[:status], row[:priority], row[:labels]
  c.save

  agent = User.find_or_create_by_email row[:agent]
  agent.act_as_agent row[:group_name]
  agent.save

  user = User.find_or_create_by_email row[:requestor]

  puts "CASE"
  puts c.inspect
  puts

  puts "Agent"
  puts agent.inspect
  puts

  puts "User"
  puts user.inspect
  puts

  count += 1
  break if count >= max
end