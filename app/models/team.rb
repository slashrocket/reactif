class Team < ActiveRecord::Base
  has_many :teamgifs
  has_many :gifs, :through => :teamgifs
end
