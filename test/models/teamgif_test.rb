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

require 'test_helper'

class TeamgifTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
