class DocsRenderer < Redcarpet::Render::HTML
  def initialize(extensions = {})
    super({
      :with_toc_data => true
    }.merge(extensions))
  end

  def preprocess(document)
    @document = document
  end

  def paragraph(content)
    if ['[TOC]', '{:toc}'].include?(content)
      toc_render = Redcarpet::Render::HTML_TOC.new(nesting_level: 3)
      parser     = Redcarpet::Markdown.new(toc_render)

      parser.render(@document)
    else
      super(content)
    end
  end

  def block_code(code, language)
    %(<pre><code class="language-#{language}">#{code}</code></pre>)
  end
end
