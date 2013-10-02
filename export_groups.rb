#!/usr/bin/env ruby
require './user.rb'
require './string_extension.rb'

outfile = File.open('./Groups.csv', "wb")
outfile << (["Name", "Agent"].join(','))
outfile << "\n"

User.load_storage

User.storage.each_pair do |email, user|
  # Write to output csv
  # Skip if Twitter user
  # next if user.twitter?
  next if user.type == 'end user'

  quoted = Array.new
  # [user.group_name, user.email].each do |element|
  # take care of multiple groups
    quoted << element.to_s.quote
  end
  outfile << quoted.join(',')
  outfile << "\n"
end
outfile.close

