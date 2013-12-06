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
outfile << (["Ticket #", "Subject", "Description", "Creation Date [yyyy-MM-dd HH:mm:ss z]", "Closure Date [yyyy-MM-dd HH:mm:ss z]", "Requester [id]", "Group", "Assignee [id]", "Type", "Status", "Priority", "Tags", "Queue", "Emailed To[23683173]", "User IP[23721196]", "WEB agent[23690807]", "Referrer URL[23690817]", "Web cookie[23683183]", "Thread ID[23721206]"]).join(',')
outfile << "\n"

# outfile2 = File.open('./output/Ticket Comments.csv', "wb")
# outfile2 << (["Ticket #", "Ticket Comment #", "Comment", "Creation Date [yyyy-MM-dd HH:mm:ss z]", "Author [id]", "Public"]).join(',')
# outfile2 << "\n"

outfileq = File.open('./output/queue.txt', "wb")
outfileq << "curl -u sthomas@tripadvisor.com/token:vdMEFozRs7MKDhtEnGH8WfBsYkJwWyo0aNltbjxa -v -H \"Content-Type: application/json\" -X POST https://tripadvisor1.zendesk.com/api/v2/ticket_fields.json -d'"
outfileq << "{ \"ticket_field\":{\"type\":\"tagger\",\"title\":\"Queue\",\"custom_field_options\": ["
outfileq << "\n"

uniqueq = Hash.new


CSV.foreach(csv_filename, :headers=>true) do |row|
  c = Case.new row["Ticket#"], row["Subject"], row["DESCRIPTION"], row["Create Date"], row["Closure Date"], row["Requester"], row["Group"], row["Assignee"], row["Type"], row["Status"], row["Priority"], row["Tags"], row["queue"], row["Emailed To"], row["UserIP"], row["WEbagent"], row["ReferrerURL"], row["Webcookie"], row["ThreadId"]
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

  # # add requester info into database if necessary (always overwrite with user email)
  # requester_email = row["Client Email"]
  # if requester_email.nil?
  #   requester = User.default_user
  # else
  #   requester = User.find_or_create_by_key row["Client ID"]
  #   requester.email = requester_email.formatted_email
  #   requester.name = requester.email.formatted_name if requester.name.nil?
  #   requester.organization = row["Location ID"]
  # end

  # # check to see if assignee is actually listed
  # # if row["Assigned To"].downcase!=""
  # if !row["Assigned To"].nil?
  #   # check to see if assignee exist before adding it
  #   assignee = User.find_by_key row["Assigned To"]
  #   if assignee.nil?
  #     # assignee doesn't currently exist in database
  #     # add to database with a dummy email
  #     assignee = User.find_or_create_by_key row["Assigned To"]
  #     assignee.email = "unknown_assignee_"+row["Last Name Assigned To"]+"@muscogee.k12.ga.us"
  #     assignee.name = assignee.email.formatted_name if assignee.name.nil?
  #     assignee.organization = row["Location ID"]
  #     assignee.act_as_agent c.group
  #   else
  #     # assignee already exist in database
  #     # add group name if necessary
  #     assignee.act_as_agent c.group
  #   end
  # else
  #   # assignee not listed
  #   # use default agent if ticket is closed
  #   if c.closed?
  #     assignee = User.default_agent
  #   else
  #     # ok to keep assigne blank if ticket is not closed
  #     assignee = User.new nil # nil id, nil email
  #   end
  # end

  # trip advisor
  # check to see if requester field is defined or not
  if row["Requester"].nil? | row["Requester"].empty?
    #requester field not defined. use default user
    requester = User.default_user
  else
    # requester is defined.  let's create if necessary
    requester = User.find_or_create_by_key row["Requester"]
  end

  # check to see if assignee field is defined or not
  if row["Assignee"].nil? | row["Assignee"].empty?
    #assignee field not defined. check to see if ticket status is closed or not
    if c.closed?
      # use default assignee
      assignee = User.default_agent
    else
      # ticket status is not closed, so just leave it blank
      assignee = User.new nil
    end
  else
    # assignee is defined.  create if necessary
    assignee = User.find_or_create_by_key row["Assignee"]
    assignee.act_as_agent row["Group"]
  end

  # output on console for debugging
  # puts c.inspect

  # Write to output csv
  quoted = Array.new
  [c.id, c.subject, c.description, c.create_date, c.closure_date, requester.id, c.group, assignee.id, c.type, c.status, c.priority, c.tags, c.queue, c.emailed_to, c.userip, c.webagent, c.referrerURL, c.webcookie, c.threadid].each do |element|
    quoted << element.to_s.quote
  end
  outfile << quoted.join(',')
  outfile << "\n"


  # # write outout for "ticket comments" only if resolution is not empty
  # if !c.resolution.nil?
  #   quoted2 = Array.new
  #   [c.id, count+1, c.resolution, c.comment_created_at, assignee.id, "TRUE"].each do |element|
  #     quoted2 << element.to_s.quote
  #   end
  #   outfile2 << quoted2.join(',')
  #   outfile2 << "\n"
  # end

  uniqueq [row["queue"]] = c.queue

  count += 1
  next if max.nil? || max==0
  break if count >= max
end

uniqueq.each do |key,value|
  outfileq << "{\"name\" : \"" + key + "\",\n"
  outfileq << "\"value\" : \"" + value + "\"},"
  outfileq << "\n"
end
outfileq << "]}}'"



# Dump current User database
User.dump_storage
outfile.close
# outfile2.close
outfileq.close