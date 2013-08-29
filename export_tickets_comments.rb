#!/usr/bin/env ruby

require 'csv'
require './case.rb'
require './user.rb'
require './message.rb'

csv_filename = ARGV.shift
max = ARGV.shift.to_i
count = 0

# Write header file
out_filename = './Tickets Comments.csv'
out_csv = CSV.open(out_filename, "wb")
out_csv << ["Ticket #", "Ticket Comment #", "Comment", "Creation Date [US]", "Author [id]", "Public"]

CSV.foreach(csv_filename, :headers=>true, :header_converters=>:symbol) do |row|
  message = Message.new row[:case_id], row[:message_id], row[:message], row[:creation_date], row[:author], row[:public]
  message.save
  author = User.find_or_create_by_email row[:author]

  # Write to output csv
  out_csv << [message.case_id, message.id, message.body, message.created_at, author.id, message.formatted_public]

  count += 1
  break if count >= max
end

out_csv.close