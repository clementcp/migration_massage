require 'time'

class String
  def quote
    "\"#{escaped}\""
  end

  def escaped
    self.gsub '"', '\"'
  end

  def formatted_time
    return '' if self.downcase=='null'
    # Time.parse(self).strftime("%m/%d/%Y %T")
    Time.parse(self).strftime("%Y-%m-%d %T GMT-08:00")
  end
end