require 'timecop'
require 'rails_helper'

describe SearchController do
  describe "POST #slack", vcr: true do
    
    let(:team) { FactoryGirl.create(:team) }

    context "when params aren't correct" do
      it "should return 'No gifs found' if the query doesn't return gifs" do
        post :slack, text: "asdadas", channel_name: "testing_reactif", user_name: Faker::Internet.user_name, team_domain: team.domain
        expect(response.body).to eq('No gifs found')
      end

      it "should return  'Team not found' of the team wasn't registered" do
        post :slack, text: "dude", channel_name: "testing_reactif", user_name: Faker::Internet.user_name, team_domain: "inventedteam"
        expect(response.body).to eq('Team not found')
      end
    end

    context "when params are alright" do
      # we need to test more than this... but... let's get the essentials out...
      it "should not return errors if all params are valid" do
        post :slack, text: "dude", channel_name: "testing_reactif", user_name: Faker::Internet.user_name, team_domain: team.domain
        expect(response).to be_success
      end

      it "should add gifs if all params are valid" do
        gifs_count = Gif.count
        post :slack, text: "dude", channel_name: "testing_reactif", user_name: Faker::Internet.user_name, team_domain: team.domain
        expect(Gif.count).not_to eq(gifs_count)
      end

      it "should count votes when a gif is upvoted or downvoted" do
        post :slack, text: "dude", channel_name: "testing_reactif", user_name: Faker::Internet.user_name, team_domain: team.domain
        gif = Lastgif.find(team_domain: team.domain, channel: "testing_reactif").first
        post :slack, text: "upvote", channel_name: "testing_reactif", user_name: "user1", team_domain: team.domain
        expect(team.teamgifs.find_by_gif_id(gif.gif_id).votes).not_to eq(25)
        post :slack, text: "downvote", channel_name: "testing_reactif", user_name: "user2", team_domain: team.domain
        expect(team.teamgifs.find_by_gif_id(gif.gif_id).votes).to eq(25)
      end

      it "should not allow users to vote more than once a week the same gif" do
        post :slack, text: "dude", channel_name: "testing_reactif", user_name: Faker::Internet.user_name, team_domain: team.domain
        gif = Lastgif.find(team_domain: team.domain, channel: "testing_reactif").first
        post :slack, text: "upvote", channel_name: "testing_reactif", user_name: "user1", team_domain: team.domain
        expect(team.teamgifs.find_by_gif_id(gif.gif_id).votes).to eq(26)
        post :slack, text: "upvote", channel_name: "testing_reactif", user_name: "user1", team_domain: team.domain
        expect(team.teamgifs.find_by_gif_id(gif.gif_id).votes).to eq(26)
        post :slack, text: "downvote", channel_name: "testing_reactif", user_name: "user1", team_domain: team.domain
        expect(team.teamgifs.find_by_gif_id(gif.gif_id).votes).to eq(26)
        Timecop.freeze(Time.now + 8.days)
        post :slack, text: "downvote", channel_name: "testing_reactif", user_name: "user1", team_domain: team.domain
        expect(team.teamgifs.find_by_gif_id(gif.gif_id).votes).to eq(25)
      end
    end

  end
end