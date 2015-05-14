class Scraper < ActiveRecord::Base
  include ReactionGIFS

  class << self
    def get_gif(search_query)
      return nil unless search_query.present?
      @encoded_search_query = encoded_search_query(search_query)
      gif_links
    end

    def encoded_search_query(search_query)
      URI.encode(search_query)
    end

    # you can add here another gif services
    def gif_links
      [
          reaction_gif_links(@encoded_search_query)
      ].flatten
    end
  end
end
