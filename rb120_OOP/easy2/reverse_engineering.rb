class Transform
  def initialize(data)
    @data = data
  end

  def uppercase
    @data.upcase
  end

  def self.lowercase(str)
    str.downcase
  end
end