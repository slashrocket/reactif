# == Schema Information
#
# Table name: teamgifs
#
#  id         :integer          not null, primary key
#  gif_id     :integer
#  team_id    :integer
#  votes      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Teamgif < ActiveRecord::Base
  belongs_to :gif
  belongs_to :team
  
  def upvote
    self.votes += 1
    self.save!
  end
  
  def downvote
    self.votes -= 1
    self.save!
  end
  
end
