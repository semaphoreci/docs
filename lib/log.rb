class Log

  def initialize(text)
    @text = text
  end

  def colourize(colour_code)
    "\e[#{colour_code}m#{@text}\e[0m"
  end

  def green
    puts colourize(32)
  end

  def yellow
    puts colourize(33)
  end

  def grey
    puts colourize(37)
  end

  def blue
    puts colourize(34)
  end

end
