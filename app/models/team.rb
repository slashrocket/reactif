# == Schema Information
#
# Table name: teams
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  domain     :string
#  webhook    :string
#

class Team < ActiveRecord::Base
  has_many :teamgifs
  has_many :gifs, through: :teamgifs
  belongs_to :user

  validates :domain, presence: true
  validates :webhook, uniqueness: { message: 'webhook already in use' }
end
