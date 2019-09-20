#!/usr/bin/env ruby

require "net/http"
require "json"
require "redcarpet"

require_relative "lib/log.rb"
require_relative "lib/help_scout.rb"
require_relative "lib/convert.rb"
require_relative "lib/docs_renderer.rb"

if ENV["DOCS_API_KEY"].nil?
  Log.new("Environment variable DOCS_API_KEY is not set. Exiting..").yellow
  exit 1
end

class Arhivator

  def update_file(file_path)
    html = Convert.to_html(file_path)
    Log.new("Converted #{file_path} to html").green
    Log.new("Take a look at its first few chars").blue
    Log.new(html.slice(0, 20)).green

    HelpScout.new.update_doc(article_id(file_path), html)
  end

  def update_all
    list_md_files.each do |file|
      update_file(file)
    end
  end

  def article_id(file)
    file_name(file).split("_").last
  end

  def file_name(file)
    file.split(".").first
  end

  def list_md_files
    Dir["*_*.md"]
  end

end

Arhivator.new.update_all
