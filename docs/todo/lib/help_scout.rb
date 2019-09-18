require_relative "log.rb"

class HelpScout

  CONTENT_TYPE_JSON = "application/json"
  API_KEY = ENV['DOCS_API_KEY']
  PORT = 443
  BASE_URL = "docsapi.helpscout.net"
  ARTICLES_URL = "/v1/articles/"

  def initialize
    @http ||= Net::HTTP.new(BASE_URL, PORT)
    @http.use_ssl = true
  end

  def update_doc(article_id, text)
    request = Net::HTTP::Put.new(article_path(article_id))
    request.body = JSON.generate({ "text": text })

    Log.new("Trying to update the doc").yellow

    trigger(request)

    log_article_details(article_id)
  end

  def get_article_details(article_id)
    request = Net::HTTP::Get.new(article_path(article_id))
    response = trigger(request)

    details = JSON.parse(response.body)
  end

  private

  def trigger(request)
    request.basic_auth API_KEY, "X"

    request.content_type = CONTENT_TYPE_JSON
    request['Connection'] = 'keep-alive'
    response = @http.request(request)
  end

  def article_path(id)
    [ARTICLES_URL, id].join
  end

  def full_article_path(article_id)
    [BASE_URL, article_path(article_id)].join
  end

  def log_article_details(article_id)
    data = get_article_details(article_id)

    is_article_found?(data) ? display_article_details(data, article_id) : output_response_details(data, article_id)
  end

  def is_article_found?(data)
    data.key?("article")
  end

  def output_response_details(response, article_id)
    Log.new("HelpScout response is").red
    Log.new(response).yellow
    Log.new("It appears that something went wrong").red
    Log.new("Please check instructions in README").red
    Log.new("Also it would be good to verify if article exists on HelpScout").red
  end

  def display_article_details(fetched_data, article_id)
    data = fetched_data["article"]

    Log.new("Updated #{full_article_path(article_id)}").green
    attributes = ["publicUrl", "status", "hasDraft", "viewCount", "popularity", "lastPublishedAt"]
    Log.new("    General article details:").green
    attributes.each do |attribute|
      Log.new("#{attribute}: #{data[attribute]}").blue
    end
  end
end
