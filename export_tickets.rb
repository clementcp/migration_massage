#!/usr/bin/env ruby

require 'csv'
require './case.rb'
require './user.rb'
require './message.rb'
require './string_extension.rb'

# csv_filename = ARGV.shift
# max = ARGV.shift.to_i
# count = 0


csv_filenames = ARGV
# Check if last argument is a number
if csv_filenames.last.to_i.to_s==csv_filenames.last
  max = csv_filenames.pop.to_i # per file max
end


# Set up default support agent in case the agent was 'unassigned'
User.load_storage

# medidata
# grabbing a list of "required" agents
# requiredAgents = Hash.new

# User.storage.each_pair do |key, user|
#   next if !user.required_agent
#   requiredAgents[user.name.downcase] = user.email
# end

# puts requiredAgents.inspect

# Write header file
outfile = File.open('./output/Tickets.csv', "wb")
outfile << (["Ticket #", "Subject", "Description", "Creation Date [yyyy-MM-dd z]", "Closure Date [yyyy-MM-dd z]", "Requester [id]", "Group", "Assignee [id]", "Type", "Status", "Priority", "Tags"]).join(',')
outfile << "\n"

outfile2 = File.open('./output/Ticket Comments.csv', "wb")
outfile2 << (["Ticket #", "Ticket Comment #", "Comment", "Creation Date [yyyy-MM-dd HH:mm:ss z]", "Author [id]", "Public"]).join(',')
outfile2 << "\n"

csv_filenames.each do |csv_filename|
  puts "Processing #{csv_filename}"
  count = 0

  CSV.foreach(csv_filename, :headers=>true) do |row|
    c = Case.new row["Case Owner"], row["Case Number"], row["Priority"], row["Subject"], row["Description"], row["Case Comments"], row["Date/Time Opened"], row["Date/Time Closed"], row["Open"], row["Closed"], row["Account Name"]
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
    # if row["Requester"].nil? | row["Requester"].empty?
    #   #requester field not defined. use default user
    #   requester = User.default_userf
    # else
    #   # requester is defined.  let's create if necessary
    #   requester = User.find_or_create_by_key row["Requester"]
    # end

    # # check to see if assignee field is defined or not
    # if row["Assignee"].nil? | row["Assignee"].empty?
    #   #assignee field not defined. check to see if ticket status is closed or not
    #   if c.closed?
    #     # use default assignee
    #     assignee = User.default_agent
    #   else
    #     # ticket status is not closed, so just leave it blank
    #     assignee = User.new nil
    #   end
    # else
    #   # assignee is defined.  create if necessary
    #   assignee = User.find_or_create_by_key row["Assignee"]
    #   assignee.act_as_agent row["Group"]
    # end

    # # now check to see if AR owner is part of required agents
    # if requiredAgents.has_key? row["AR Owner"].downcase
    #   # go ahead and start processing
    #   assignee = User.find_by_key row["AR Owner"].downcase
    #   # first, check requester
    #   if row["Email"].nil?
    #     #requester's email  not defined. use default user
    #     requester = User.default_user
    #   else
    #     # requester's email is defined.  let's create if necessary
    #       requester = User.find_or_create_by_key row["Email"].formatted_email
    #       requester.email = row["Email"].formatted_email
    #     if row["Full Name"].nil? | row["Full Name"].empty?
    #       requester.name = row["Email"].formatted_email
    #     else
    #       requester.name = row ["Full Name"]
    #     end
    #   end
    # else
    #   #ignore and just go to the next one
    #   # puts "AR Owner no match - skipping"
    #   next
    # end


    # output on console for debugging
    # puts c.inspect

    # Write to output csv
    quoted = Array.new
    [c.id, c.subject, c.description, c.created_date, c.closure_date, c.case_owner, 'general', c.case_owner, c.type, c.status, c.priority, ''].each do |element|
      quoted << element.to_s.quote
    end
    outfile << quoted.join(',')
    outfile << "\n"


    # # write outout for "ticket comments"
    if !c.case_comments.nil?
      quoted2 = Array.new
      [c.id, count+1, c.case_comments, c.created_date, c.case_owner, "TRUE"].each do |element|
      quoted2 << element.to_s.quote
      end
      outfile2 << quoted2.join(',')
      outfile2 << "\n"
    end

    count += 1
    next if max.nil? || max==0
    break if count >= max
  end
end


# Dump current User database
User.dump_storage
outfile.close
outfile2.close
