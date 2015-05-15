class Lastgif < Ohm::Model
  attribute :team_domain
  attribute :channel
  attribute :gif_id

  index :team_domain
  index :channel
end