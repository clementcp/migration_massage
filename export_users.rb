#!/usr/bin/env ruby
require './user.rb'
require './string_extension.rb'

outfile = File.open('./output/Users.csv', "wb")
outfile << (["id", "Name", "Email", "Password", "Phone", "Role", "Organization", "Tags", "Details", "Notes"].join(','))
outfile << "\n"

User.load_storage

User.storage.each_pair do |key, user|
  # Write to output csv
  # Skip if Twitter user
  # next if user.twitter?

  quoted = Array.new
  [user.id, user.name, user.email, '', user.phone, user.type, user.organization, '', '', ''].each do |element|
    quoted << element.to_s.quote
  end
  outfile << quoted.join(',')
  outfile << "\n"
end
outfile.close