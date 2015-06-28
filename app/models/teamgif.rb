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

  def self.random_gif_id
    gifs = with_probability
           .map { |tg| { gif_id: tg.gif_id, probability: tg.probability } }
    prob_sum = 0
    (0..gifs.length).each do |i|
      prob_sum += gifs[i][:probability]
      return gifs[i][:gif_id] if random_number <= prob_sum
    end
  end

  private

  def self.total_votes
    sum(:votes)
  end

  def self.random_number
    @random_number ||= rand
  end

  def self.with_probability
    select("*, votes/#{total_votes.to_f} as probability")
  end
end
