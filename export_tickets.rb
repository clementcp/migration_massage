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
outfile = File.open('./output/Tickets.csv', "wb")
outfile << (["Ticket #", "Subject", "Description", "Creation Date [yyyy-MM-dd HH:mm:ss z]", "Closure Date [yyyy-MM-dd HH:mm:ss z]", "Requester [id]", "Group", "Assignee [id]", "Type", "Status", "Priority", "Tags", "Room Number[23198168]", "VirtuCom Serial Number[23152248]", "Smart Board Serial Number[21238920]", "MyRicoh Serial Number[21238930]"]).join(',')
outfile << "\n"

outfile2 = File.open('./output/Ticket Comments.csv', "wb")
outfile2 << (["Ticket #", "Ticket Comment #", "Comment", "Creation Date [yyyy-MM-dd HH:mm:ss z]", "Author [id]", "Public"]).join(',')
outfile2 << "\n"

CSV.foreach(csv_filename, :headers=>true) do |row|
  c = Case.new row["Incident #"], row["Room Number"], row ["Serial Number"], row["Client ID"], row["Client Email"], row["Location ID"], row["Incident Description"], row["Incident Resolution"], row["Category ID"], row["Open Date"], row["Close Date & Time"], row["Assigned To"], row["Last Name Assigned To"], row["Group"], row["State:"]
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

  # add requester info into database if necessary (always overwrite with user email)
  requester_email = row["Client Email"]
  requester = User.find_or_create_by_key row["Client ID"]
  requester.email = requester_email.formatted_email

  # check to see if assignee is actually listed
  if row["Assigned To"].downcase!=""
    # check to see if assignee exist before adding it
    assignee = User.find_by_key row["Assigned To"]
    if assignee.nil?
      # assignee doesn't currently exist in database
      # add to database with a dummy email
      assignee = User.find_or_create_by_key row["Assigned To"]
      assignee.email = "unknown_assignee_"+row["Last Name Assigned To"]+"@muscogee.k12.ga.us"

      assignee.act_as_agent c.group
    else
      # assignee already exist in database
      # add group name if necessary
      assignee.act_as_agent c.group
    end
  else
    # assignee not listed
    # use default agent if ticket is closed
    if c.closed?
      assignee = User.default_agent
    else
      # ok to keep assigne blank if ticket is not closed
      assignee = User.new nil # nil id, nil email
    end
  end

  # ignore cases where old group is "PS DISPATCH" or "PS ZONE EROSION CONTROL"
  if (row["Group"] == "PS DISPATCH") || (row["Group"] == "PS ZONE EROSION CONTROL")
    count += 1
    next
  end

  puts c.inspect

  # Write to output csv
  quoted = Array.new
  [c.id, c.subject, c.description, c.created_at, c.resolved_at, requester.id, c.group, assignee.id, c.type, c.status, c.priority, c.tags, c.room_number, c.v_serial_number, c.sb_serial_number, c.r_serial_number].each do |element|
    quoted << element.to_s.quote
  end
  outfile << quoted.join(',')
  outfile << "\n"

  # write outout for "ticket comments" only if resolution is not empty
  if (c.resolution != "")
    quoted2 = Array.new
    [c.id, count+1, c.resolution, c.resolved_at, assignee.id, "TRUE"].each do |element|
      quoted2 << element.to_s.quote
    end
    outfile2 << quoted2.join(',')
    outfile2 << "\n"
  end

  count += 1
  next if max.nil? || max==0
  break if count >= max
end

# Dump current User database
User.dump_storage
outfile.close
outfile2.close