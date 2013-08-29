#!/usr/bin/env ruby

require 'csv'
require './case.rb'
require './user.rb'
require './message.rb'
require './string_extension.rb'

csv_filenames = ARGV[0..ARGV.count-1]
# Check if last argument is a number
if csv_filenames.last.to_i.to_s==csv_filenames.last
  max = csv_filenames.pop.to_i # per file max
end

puts "filenames: #{csv_filenames.inspect}"
puts "max: #{max}"


outfile = File.open('./Tickets Comments.csv', "wb")
outfile << (["Ticket #", "Ticket Comment #", "Comment", "Creation Date [US]", "Author [id]", "Public"].join(', '))
outfile << "\n"

User.load_storage

# Set up default dummy user in case the author is 'customer'
default_user = User.find_or_create_by_email 'dummy_user@test_for_box.earth'
default_user.save

csv_filenames.each do |csv_filename|
  count = 0 # max is per file
  CSV.foreach(csv_filename, :headers=>true, :header_converters=>:symbol) do |row|
    message = Message.new row[:case_id], row[:message_id], row[:message], row[:creation_date], row[:author], row[:public]
    message.save

    # check to see if author is 'customer'
    if row[:author].downcase != "customer"
      author = User.find_or_create_by_email row[:author]
    else
      author = default_user
    end

    # Write to output csv
    quoted = Array.new
    [message.case_id, message.id, message.body, message.created_at, author.id, message.formatted_public].each do |element|
      quoted << element.to_s.quote
    end
    outfile << quoted.join(',')
    outfile << "\n"

    count += 1
    next if max.nil?
    break if count >= max
  end
end

User.dump_storage
outfile.close

