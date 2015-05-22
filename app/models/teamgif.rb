# == Schema Information
#
# Table name: teamgifs
#
#  id         :integer          not null, primary key
#  gif_id     :integer
#  team_id    :integer
#  votes      :integer          default(25)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Teamgif < ActiveRecord::Base
  belongs_to :gif
  belongs_to :team

  def upvote
    return if votes == 100
    self.votes += 1
    self.save!
  end

  def downvote
    return if votes == 0
    self.votes -= 1
    self.save!
  end
end
