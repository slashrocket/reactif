class Teamgif < ActiveRecord::Base
  belongs_to :gif
  belongs_to :team
end
