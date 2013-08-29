#!/usr/bin/env ruby

require 'csv'
require './case.rb'
require './user.rb'
require './message.rb'
require './string_extension.rb'

csv_filename = ARGV.shift
max = ARGV.shift.to_i
count = 0

outfile = File.open('./Tickets Comments.csv', "wb")
outfile << (["Ticket #", "Ticket Comment #", "Comment", "Creation Date [US]", "Author [id]", "Public"].join(', '))
outfile << "\n"

User.load_storage
CSV.foreach(csv_filename, :headers=>true, :header_converters=>:symbol) do |row|
  message = Message.new row[:case_id], row[:message_id], row[:message], row[:creation_date], row[:author], row[:public]
  message.save
  author = User.find_or_create_by_email row[:author]

  # Write to output csv
  quoted = Array.new
  [message.case_id, message.id, message.body, message.created_at, author.id, message.formatted_public].each do |element|
    quoted << element.to_s.quote
  end
  outfile << quoted.join(',')
  outfile << "\n"

  count += 1
  break if count >= max
end

User.dump_storage
outfile.close

