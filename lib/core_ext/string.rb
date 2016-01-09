class String
  def only_numbers
    val = String.new
    self.each_char do |n|
      val << n if NUMBERS.include?(n)
    end
    val
  end
end