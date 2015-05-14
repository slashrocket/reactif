class Gif < ActiveRecord::Base
  require 'uri'
  has_many :teams
  has_many :teamgifs
  
  validates :url, presence: true
  #validates :word, presence: true
  
  def self.getgif(searchfor)
    return nil unless searchfor.present?
    encodedsearch = URI.encode(searchfor)
    url = "http://www.reactiongifs.com/?s=#{encodedsearch}&submit=Search"
    doc = Nokogiri::HTML(open(url))
    findgifs = doc.css('div.entry p a').map { |link| link['href'] }
    #save found gifs if they are new
    findgifs.each do |x|
        if Gif.find_by_url(x).nil?
            gif = Gif.new
            gif.url = x
            gif.save!
        end
    end
    findgifs
  end
  
end
