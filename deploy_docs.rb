#!/usr/bin/env ruby

if ENV["DOCS_API_KEY"].nil?
  Log.new("Environment variable DOCS_API_KEY is not set. Exiting..").yellow
  exit 1
end

REVISION = ENV['SEMAPHORE_GIT_SHA']

require "net/http"
require "json"
require "redcarpet"

require_relative "lib/log.rb"
require_relative "lib/help_scout.rb"
require_relative "lib/convert.rb"
require_relative "lib/docs_renderer.rb"

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
    file.split("_").first
  end

  def list_md_files
    Dir["*_*.md"]
  end
end

def list_changed_articles(commit_sha)
  files = `git diff-tree --no-commit-id --name-only #{commit_sha}`
  files.split("\n") - ["README.md"]
end

changed_articles = list_changed_articles(REVISION).select { |name| name.match(/.md\z/) }

changed_articles.each do |article|
  Arhivator.new.update_file(article)
end
