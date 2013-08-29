require 'time'

class String
  def quote
    "\"#{self}\""
  end

  def formatted_time
    return '' if self.downcase=='null'
    Time.parse(self).strftime("%m/%d/%Y %T")
  end
end