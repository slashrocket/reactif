class Scraper < ActiveRecord::Base
  require 'uri'

  def self.getgif(searchfor)
    return nil unless searchfor.present?
    encodedsearch = URI.encode(searchfor)
    url = "http://www.reactiongifs.com/?s=#{encodedsearch}&submit=Search"
    doc = Nokogiri::HTML(open(url))
    findgifs = doc.css('div.entry p a').map { |link| link['href'] }
    findgifs
  end
end
