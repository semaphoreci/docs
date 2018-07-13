class Convert

  def self.to_html(file)
    markdown = File.read(file)
    Kramdown::Document.new(markdown).to_html
  end

end
