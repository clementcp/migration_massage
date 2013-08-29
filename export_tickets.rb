#!/usr/bin/env ruby

require 'csv'
require './case.rb'
require './user.rb'
require './message.rb'
require 'yaml'

csv_filename = ARGV.shift
max = ARGV.shift.to_i
count = 0

# Set up default support agent in case the agent was 'unassigned'
User.load_storage
default_agent = User.find_or_create_by_email 'zoelle@crocodoc.com'
default_agent.act_as_agent 'General'
default_agent.save

# Write header file
out_csv = CSV.open('./Tickets.csv', "wb")
out_csv << ["Ticket #", "Subject", "Description", "Creation Date [US]", "Closure Date [US]", "Requestor [id]", "Group", "Assignee [id]", "Type", "Status", "Priority", "Tags", "Test"]

CSV.foreach(csv_filename, :headers=>true, :header_converters=>:symbol) do |row|
  c = Case.new row[:case_id], row[:subject], row[:description], row[:created_at], row[:resolved_at], row[:type], row[:status], row[:priority], row[:labels]
  c.save

  user = User.find_or_create_by_email row[:requestor]

  # Skip if Twitter user
  next if user.twitter?

  if row[:agent].downcase!="unassigned"
    agent = User.find_or_create_by_email row[:agent]
    agent.act_as_agent row[:group_name]
    agent.save
  else
    if c.closed?
      agent = default_agent
    else
      agent = nil
    end
  end

  # Write to output csv
  out_csv << [c.id, c.subject, c.description, c.created_at, c.resolved_at, user.id, agent.group_name, agent.id, c.type, c.status, c.priority, c.tags]

  count += 1
  break if count >= max
end

# Dump current User database
User.dump_storage

out_csv.close