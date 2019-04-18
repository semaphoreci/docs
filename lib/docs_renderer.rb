class DocsRenderer < Redcarpet::Render::HTML
  def initialize(extensions = {})
    super({
      :with_toc_data => true
    }.merge(extensions))
  end

  def preprocess(document)
    # replace [[__TOC__]] with table of content

    toc_render = Redcarpet::Render::HTML_TOC.new(nesting_level: 3)
    parser     = Redcarpet::Markdown.new(toc_render)
    toc        = parser.render(document)

    document.sub!("[[__TOC__]]", toc)

    document
  end

  def block_code(code, language)
    %(<pre><code class="language-#{language}">#{escape_html(code)}</code></pre>)
  end

  private

  def escape_html(string)
    CGI.escapeHTML(string)
  end
end
