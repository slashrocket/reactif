module ReactionGIFS
  extend ActiveSupport::Concern

  module ClassMethods
    def reaction_gifs_response(search_query)
      Nokogiri::HTML(open(reaction_gifs_search_query(search_query)))
    end

    def reaction_gifs_search_query(search_query)
      "http://www.reactiongifs.com/?s=#{search_query}&submit=Search"
    end

    def reaction_gif_links(search_query)
      document = reaction_gifs_response(search_query)
      document.css('div.entry p a').map { |link| link['href'] }.select { |link| link[/\.gif$/] }
    end
  end
end
