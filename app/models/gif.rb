# == Schema Information
#
# Table name: gifs
#
#  id         :integer          not null, primary key
#  word       :string
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Gif < ActiveRecord::Base
  require 'uri'
  has_many :teams
  has_many :teamgifs
  
  validates :url, presence: true
  #validates :word, presence: true
  
  def self.getgifs(searchfor)
    return nil unless searchfor.present?
    encodedsearch = URI.encode(searchfor)
    url = "http://www.reactiongifs.com/?s=#{encodedsearch}&submit=Search"
    doc = Nokogiri::HTML HTTParty.get(url, {timeout: 2}).body
    return nil unless doc.present?
    findgifs = doc.css('div.entry p a').map { |link| link['href'] }
    #save found gifs if they are new
    @gifs = []
    findgifs[0..5].each do |x|
      gif = Gif.find_by_url(x)
      if gif.nil?
          gif = Gif.new
          gif.url = x
          gif.word = searchfor
          gif.save!
      end
      @gifs << gif
    end
    @gifs
  end
  
end
