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
    # Time.strptime(self,"%m/%d/%y %H:%M").strftime("%Y-%m-%d %T GMT-05:00")
    # Time.strptime(self,"%Y-%m-%d %H:%M:%S").strftime("%Y-%m-%d %T GMT-05:00")
    Time.strptime(self,"%m/%d/%Y").strftime("%Y-%m-%d GMT-05:00")
  end

def formatted_time_comment
    return '' if self.downcase=='null'
    Time.strptime(self,"%m/%d/%Y %k:%M").strftime("%Y-%m-%d %T GMT-05:00")
  end


  # for muscongee
  # def formatted_email
    # self.gsub! /\{(.*?)\}/, ""
  #   self.gsub! "SMTP:", ""
  # end

  # for trip advisor
  # def formatted_email
  #   self.gsub '=', '-'
  # end

  # for medidata
  def formatted_email
    if self.downcase == '(blank)'
      self
    end
    temail = self.gsub ';', ','
    temail.gsub! /[*<(>)"\s\t]/, ''
    # temail.gsub! /\s/, ''
    temail.split(',')[0]
  end

  def formatted_phone
    return self if self.nil?
    self.gsub /[\t]/, ''
  end

  def formatted_name
    return self if self.nil?
    self.gsub /[\s\t\r\n]/, ''
  end


  # def formatted_name
  #   l_name, f_name, m_name = self.split('@').first.split('.')
  #   if m_name.nil?
  #     "#{f_name} #{l_name}"
  #   else
  #     "#{f_name} #{m_name} #{l_name}"
  #   end
  # end

  def formatted_queue
    tqueue = self.gsub /[()]/, ''
    tqueue.gsub! ' - ', '_'
    tqueue.gsub! ' ', '_'
    tqueue.gsub! '/', '_'
    tqueue.downcase!
  end

  # def formatted_id
  #   self.gsub '1-', ''
  # end

end
