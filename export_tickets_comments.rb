#!/usr/bin/env ruby

require 'csv'
require './case.rb'
require './user.rb'
require './message.rb'
require './string_extension.rb'

csv_filenames = ARGV
# Check if last argument is a number
if csv_filenames.last.to_i.to_s==csv_filenames.last
  max = csv_filenames.pop.to_i # per file max
end

outfile = File.open('./output/Ticket Comments.csv', "wb")
outfile << (["Ticket #", "Ticket Comment #", "Comment", "Creation Date [yyyy-MM-dd HH:mm:ss z]", "Author [id]", "Public"].join(', '))
outfile << "\n"

User.load_storage
csv_filenames.each do |csv_filename|
  puts "Processing #{csv_filename}"
  count = 0 # max is per file
  # CSV.foreach(csv_filename, :headers=>true, :header_converters=>:symbol) do |row|
    # message = Message.new row[:case_id], row[:message_id], row[:message], row[:creation_date], row[:author], row[:public]

  CSV.foreach(csv_filename, :headers=>true) do |row|
    message = Message.new row["Ticket#"], row["TicketComment"], row["Comment"], row["Creation Date"], row["Public"]
    message.save

    # puts message.inspect

    # # check to see if author is defined
    if row["Author"].nil? || row["Author"].empty?
      # author is nil
      author = User.default_commenter
    else
      # author is defined! look for it
      # check to see if author is email or name
      if row["Author"].include? "@"
        # author field contains email
        author = User.find_or_create_by_key row["Author"].formatted_email
        if author.name.nil?
          author.name = row["Author"]
        end
      else
        # author field doesn't contain email
        author = User.find_by_name row["Author"]
        if author.nil?
          # authur doesn't currently exist in database
          # add to database with a dummy email
          author = User.new row["Author"].format_name_into_email
          author.name = row["Author"]
          author.act_as_agent "General"
        end
      end
    end
    author.save

    # if message.id == "23050"
    #   puts message.inspect
    # end

    # Write to output csv
    quoted = Array.new
    # [message.case_id, message.id, message.body, message.created_at, author.id, message.formatted_public].each do |element|
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

