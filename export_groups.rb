#!/usr/bin/env ruby
require './user.rb'
require './string_extension.rb'

outfile = File.open('./output/Groups.csv', "wb")
outfile << (["Name", "Agent"].join(','))
outfile << "\n"

User.load_storage

User.storage.each_pair do |key, user|
  # Write to output csv
  # Skip if Twitter user
  # next if user.twitter?
  next if user.type == 'end user'

  # quoted = Array.new
  # [user.group_name, user.email].each do |element|
  #   quoted << element.to_s.quote
  # end

  user.groups_name.each do |group_name|
    quoted = Array.new
    [group_name, user.name].each do |element|
      quoted << element.to_s.quote
    end

    outfile << quoted.join(',')
    outfile << "\n"
  end

end
outfile.close

