#!/usr/bin/env ruby

require "net/http"
require "json"
require "kramdown"

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

class HelpScout

  CONTENT_TYPE_JSON = "application/json"
  BASE_URL = "docsapi.helpscout.net"
  PORT = 443
  ARTICLES_URL = "/v1/articles/"
  API_KEY = ENV['DOCS_API_KEY']

  def initialize
    @http ||= Net::HTTP.new(BASE_URL, PORT)
    @http.use_ssl = true
  end

  def update_doc(article_id, text)
    request = Net::HTTP::Put.new(path(article_id))
    request.body = JSON.generate({ "text": text })

    Log.new("Trying to update the doc").yellow

    trigger(request)

    log_article_details(article_id)
  end

  def log_article_details(article_id)
    data = get_article_details(article_id)["article"]

    Log.new("Updated #{full_path(article_id)}").green
    attributes = ["publicUrl", "status", "hasDraft", "viewCount", "popularity", "lastPublishedAt"]
    Log.new("    General article details:").green
    attributes.each do |attribute|
      Log.new("#{attribute}: #{data[attribute]}").blue
    end
  end

  private

  def trigger(request)
    request.basic_auth API_KEY, "X"

    request.content_type = CONTENT_TYPE_JSON
    request['Connection'] = 'keep-alive'
    response = @http.request(request)
  end

  def path(article_id)
    [ARTICLES_URL, article_id].join
  end

  def full_path(article_id)
    [BASE_URL, path(article_id)].join
  end

  def get_article_details(article_id)
    request = Net::HTTP::Get.new(path(article_id))
    response = trigger(request)

    details = JSON.parse(response.body)
  end

end

class Convert

  def self.to_html(file)
    markdown = File.read(file)
    Kramdown::Document.new(markdown).to_html
  end

end

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

SendData.new.send_all
