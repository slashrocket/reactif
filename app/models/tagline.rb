class Tagline < ActiveRecord::Base
  validates :header, :query, presence: true

  def self.random
    Tagline.order("RANDOM()").first
  end
end
