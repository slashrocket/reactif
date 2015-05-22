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
  include ReactionGIFS

  has_many :teams
  has_many :teamgifs

  validates :url, presence: true
  validates :word, presence: true

  class << self
    def getgifs(search_query)
      return nil unless search_query.present?

      @encoded_search_query = encode_query search_query
      save_gifs search_query
    end

    def encode_query(search_query)
      URI.encode(search_query)
    end

    # Save found gifs if they are new
    def save_gifs(search_query)
      gif_links.map do |url|
        Gif.find_or_create_by(url: url, word: search_query)
      end
    end

    # You can add here another gif services
    def gif_links
      [reaction_gif_links(@encoded_search_query)].flatten
    end
  end
end
