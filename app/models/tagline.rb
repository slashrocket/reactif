# == Schema Information
#
# Table name: taglines
#
#  id         :integer          not null, primary key
#  header     :string
#  query      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Tagline < ActiveRecord::Base
  validates :header, :query, presence: true

  def self.random
    Tagline.limit(1).order('RANDOM()')
  end
end
