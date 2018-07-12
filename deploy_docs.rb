#!/usr/bin/env ruby

require "net/http"
require "json"
require "kramdown"

class UpdateDocs

  CONTENT_TYPE_JSON = "application/json"
  BASE_URL = "docsapi.helpscout.net"
  PORT = 443
  ARTICLES_URL = "/v1/articles/"
  API_KEY = ENV['DOCS_API_KEY']

  def initialize
    @http = Net::HTTP.new(BASE_URL, PORT)
    @http.use_ssl = true
  end

  def put(article_id, text)
    request = Net::HTTP::Put.new(path(article_id))
    request.basic_auth API_KEY, "X"

    request.content_type = CONTENT_TYPE_JSON
    request.body = JSON.generate({ "text": text })
    trigger(request)
  end

  private

  def trigger(request)
    request['Connection'] = 'keep-alive'
    response = @http.request(request)
  end

  def path(article_id)
    [ARTICLES_URL,article_id].join
  end
end

class Convert

  def self.to_html(file)
    markdown = File.read(file)
    Kramdown::Document.new(markdown).to_html
  end

end
