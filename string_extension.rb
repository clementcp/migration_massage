require 'time'

class String
  def quote
    "\"#{self}\""
  end

  def formatted_time
    return Time.parse(self).strftime("%m/%d/%Y %T") if self != 'null'
    ''
  end
end