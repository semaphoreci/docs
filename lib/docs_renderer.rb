class DocsRenderer < Redcarpet::Render::HTML
  def initialize(extensions = {})
    super({
      :with_toc_data => true
    }.merge(extensions))
  end

  def block_code(code, language)
    %(<pre>#{code}</pre>)
  end
end
