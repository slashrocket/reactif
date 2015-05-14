class Scraper < ActiveRecord::Base
    require 'uri'

    def self.getgif(searchfor)
        encodedsearch = URI.encode(searchfor)
        url = "http://www.reactiongifs.com/?s=#{encodedsearch}&submit=Search"
        doc = Nokogiri::HTML(open(url))
        findgifs = doc.css('div.entry p a').map { |link| link['href'] }
        return findgifs
    end
    
end
