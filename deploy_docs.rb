#!/usr/bin/env ruby

require "net/http"
require "json"
require "kramdown"

require_relative "lib/help_scout.rb"
require_relative "lib/log.rb"
require_relative "lib/convert.rb"

class SendData
  def send_all
    list_md_files.each do |file|
      html = Convert.to_html(file)
      Log.new("Converted #{file} to html").green
      Log.new("Take a look at its first few chars").grey
      Log.new(html.slice(0, 20)).grey

      HelpScout.new.update_doc(article_id(file), html)
    end
  end

  def article_id(file)
    file.split("_").first
  end

  def list_md_files
    Dir["*_*.md"]
  end
end

SendData.new.send_all
