class Convert

  def self.to_html(file)
    markdown = Redcarpet::Markdown.new(DocsRenderer, fenced_code_blocks: true)
    file = File.read(file, :encoding => "utf-8")
    markdown.render(file)
  end

  def self.save_as_markdown(file_name, content)
    markdown = Kramdown::Document.new(content, :html_to_native => true).to_kramdown
    output = File.new(file_name, "w")
    output.puts(markdown)
    output.close
  end

end
