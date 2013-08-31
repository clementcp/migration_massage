#!/usr/bin/env ruby

require './user.rb'

User.load_storage

saved = {}
by_ids = {}
User.storage.each_pair do |email, user|
  # if saved[email]
  #   puts "*** prev #{saved[email]}"
  #   puts "*** now  #{user}"
  #   break
  # else
  #   saved[email] = user
  # end

  if by_ids[user.id]
    puts "*** prev #{by_ids[user.id].inspect}"
    puts "*** now  #{user.inspect}"
  else
    by_ids[user.id] = user
  end

end