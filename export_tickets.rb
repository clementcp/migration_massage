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
outfile << (["Ticket #", "Subject", "Description", "Creation Date [yyyy-MM-dd HH:mm:ss z]", "Closure Date [yyyy-MM-dd HH:mm:ss z]", "Requester [id]", "Group", "Assignee [id]", "Type", "Status", "Priority", "Tags", "Queue[23746227]", "Emailed To[23741833]", "User IP[23753458]", "WEB agent[23753438]", "Referrer URL[23753448]", "Web cookie[23741843]", "Thread ID[23753468]"]).join(',')
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
  c = Case.new row["Ticket#"], row["Subject"], row["DESCRIPTION"], row["Create Date"], row["Closure Date"], row["Type"], row["Status"], row["Priority"], row["Tags"], row["queue"], row["Emailed To"], row["UserIP"], row["WEbagent"], row["ReferrerURL"], row["Webcookie"], row["ThreadId"]
  c.save

  # trip advisor
  # check to see if requester field is defined or not
  if row["Requester"].nil? || row["Requester"].empty?
    #requester field not defined. use default user
    requester = User.default_user
  else
    # requester is defined.  let's create if necessary
    # check to see if requester is email or name
    if row["Requester"].include? "@"
      # requester field contains email
      requester = User.find_or_create_by_key row["Requester"].formatted_email
      if requester.name.nil?
        requester.name = row["Requester"]
      end
    else
      # requester field doesn't contain email
      requester = User.find_by_name row["Requester"]
      # check to see if requester exists or not
      if requester.nil?
        # requester doesn't exist! make it up!
        requester = User.new row["Requester"].format_name_into_email
        requester.name = row["Requester"]
      end
    end
  end
  requester.save

  # check to see if assignee field is defined or not
  if row["Assignee"].nil? || row["Assignee"].empty?
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
    # check to see if assignee is email or name
    if row["Assignee"].include? "@"
      # assignee field contains email
      assignee = User.find_or_create_by_key row["Assignee"].formatted_email
      if assignee.name.nil?
        assignee.name = row["Assignee"]
      end
    else
      # assignee field doesn't contain email
      assignee = User.find_by_name row["Assignee"]
      if assignee.nil?
        # assignee doesn't exist! make it up!
        assignee = User.new row["Assignee"].format_name_into_email
        assignee.name = row["Assignee"]
      end
    end
  end
  assignee.act_as_agent row["Group"]
  assignee.save

  # output on console for debugging
  # puts c.inspect

  # Write to output csv
  quoted = Array.new
  [c.id, c.subject, c.description, c.create_date, c.closure_date, requester.id, row["Group"], assignee.id, c.type, c.status, c.priority, c.tags, c.queue, c.emailed_to, c.userip, c.webagent, c.referrerURL, c.webcookie, c.threadid].each do |element|
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