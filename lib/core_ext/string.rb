class String
  def only_numbers
    val = ""
    self.each_char do |n|
      val << n if NUMBERS.include?(n)
    end
    val
  end

  # string#to_symbol != string#to_sym
  # 'A lot'.to_symbol #=> :a_lot
  def to_symbol
  	self.downcase.split.join('_').to_sym
  end
end
