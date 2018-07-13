require_relative "log.rb"
require_relative "help_scout.rb"

class DownloadCategory < HelpScout

  CATEGORIES_URL = "/v1/categories/"

  def self.save_articles(category_id)
    articles = new.get_articles_in_category(category_id)

    articles.each do |article_id|
      article = new.get_article_details(article_id)["article"]

      article_html = article["text"]
      article_slug = article["slug"]

      file_name = "#{article_id}_#{article_slug}.md"
      Convert.save_as_markdown(file_name, article_html)
    end
  end

  def get_articles_in_category(category_id)
    request = Net::HTTP::Get.new(category_path(category_id))
    response = trigger(request)

    article_ids = JSON.parse(response.body)["articles"]["items"].map { |item| item["id"] }
    Log.new("#{category_id} category has articles with #{article_ids.to_s} ids").yellow
    article_ids
  end

  private

  def category_path(id)
    [CATEGORIES_URL, id, "/articles"].join
  end

end
