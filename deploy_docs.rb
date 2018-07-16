#!/usr/bin/env ruby

require_relative "lib/log.rb"

if ENV["DOCS_API_KEY"].nil?
  Log.new("Environment variable DOCS_API_KEY is not set. Exiting..").yellow
  exit 1
end

require "net/http"
require "json"
require "kramdown"

require_relative "lib/help_scout.rb"
require_relative "lib/convert.rb"

class Arhivator

  def update_file(file_path)
    html = Convert.to_html(file_path)
    Log.new("Converted #{file_path} to html").green
    Log.new("Take a look at its first few chars").grey
    Log.new(html.slice(0, 20)).grey

    HelpScout.new.update_doc(article_id(file_path), html)
  end

  def update_all
    list_md_files.each do |file|
      update_file(file)
    end
  end

  def article_id(file)
    file.split("_").first
  end

  def list_md_files
    Dir["*_*.md"]
  end
end


Arhivator.new.update_all
