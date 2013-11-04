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
    # Time.parse(self).strftime("%Y-%m-%d %T GMT-08:00")
    # for muscogee
    # Time.strptime(self,"%m/%d/%Y %H:%M:%S %p").strftime("%Y-%m-%d %T GMT-05:00")
    Time.strptime(self,"%m/%d/%y %H:%M").strftime("%Y-%m-%d %T GMT-05:00")

  end

  def formatted_email
    self.gsub! /\{(.*?)\}/, ""
    self.gsub! "SMTP:", ""
  end

  def formatted_name
    l_name, f_name, m_name = self.split('@').first.split('.')
    if m_name.nil?
      "#{f_name} #{l_name}"
    else
      "#{f_name} #{m_name} #{l_name}"
    end
  end
end