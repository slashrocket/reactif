class Gifvotes < Ohm::Model
  attribute :team_domain
  attribute :channel
  attribute :username
  attribute :gif_id
  attribute :expiration

  index :team_domain
  index :channel
  index :username
  index :gif_id
end