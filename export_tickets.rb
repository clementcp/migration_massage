#!/usr/bin/env ruby

require 'csv'
require './case.rb'
require './user.rb'
require './message.rb'
require './string_extension.rb'

csv_filename = ARGV.shift
max = ARGV.shift.to_i
count = 0

# Set up default support agent in case the agent was 'unassigned'
User.load_storage

# Write header file
outfile = File.open('./Tickets.csv', "wb")
outfile << (["Ticket #", "Subject", "Description", "Creation Date [yyyy-MM-dd HH:mm:ss z]", "Closure Date [yyyy-MM-dd HH:mm:ss z]", "Requester [id]", "Group", "Assignee [id]", "Type", "Status", "Priority", "Tags", "Room Number[23198168]", "VirtuCom Serial Number[23152248]"]).join(',')
outfile << "\n"

CSV.foreach(csv_filename, :headers=>true) do |row|
  c = Case.new row["Incident #"], row["Room Number"], row ["Serial Number"], row["Client ID"], row["Client Email"], row["Location ID"], row["Incident Description"], row["Incident Resolution"], row["Category ID"], row["Open Date"], row["Close Date & Time"], row["Assigned To"], row["Last Name Assigned To"], row["Group"], row["State"]
  c.save

  # user = User.find_or_create_by_key row[:requestor]

  # if row[:agent].downcase!="unassigned"
  #   agent = User.find_or_create_by_key row[:agent]
  #   agent.act_as_agent row[:group_name]
  #   agent.save
  # else
  #   if c.closed?
  #     agent = User.default_agent
  #   else
  #     agent = User.new nil # nil id, nil email
  #   end
  # end

  user_email = row["Client Email"]
  user_email.formatted_email

  user = User.find_or_create_by_key user_email

  if row["Last Name Assigned To"].downcase!=""
    agent_email =
    agent = User.find_or_create_by_key row[:agent]
    agent.act_as_agent c.group
    agent.save
  else
    if c.closed?
      agent = User.default_agent
    else
      agent = User.new nil # nil id, nil email
    end
  end


  # Write to output csv
  quoted = Array.new
  [c.id, c.subject, c.description, c.created_at, c.resolved_at, user.id, agent.group, agent.id, c.type, c.status, c.priority, c.tags, c.room_number, c.v_serial_number].each do |element|
    quoted << element.to_s.quote
  end
  outfile << quoted.join(',')
  outfile << "\n"

  count += 1
  next if max.nil? || max==0
  break if count >= max
end

# Dump current User database
User.dump_storage
outfile.close