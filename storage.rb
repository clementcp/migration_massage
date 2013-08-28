module Storage
  def storage
    @@storage ||= Hash.new
  end

  def find_by_id id
    storage[id]
  end

  def save c
    storage[c.id] = c
  end
end