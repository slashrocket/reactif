require 'timecop'
require 'rails_helper'

describe SearchController do
  describe "POST #slack", vcr: true do
    
    let(:team) { FactoryGirl.create(:team) }
    let!(:post_params) { post_params = {text: "dude", channel_name: "testing_reactif", user_name: Faker::Internet.user_name, team_domain: team.domain}}

    context "when params aren't correct" do
      it "should return 'No gifs found' if the query doesn't return gifs" do
        post_params[:text] = "asdadas"
        post :slack, post_params
        expect(response.body).to eq('No gifs found')
      end

      it "should return  'Team not found' of the team wasn't registered" do
        post_params[:team_domain] = "inventedteam"
        post :slack, post_params
        expect(response.body).to eq('Team not found')
      end
    end

    context "when params are alright" do
      # we need to test more than this... but... let's get the essentials out...
      it "should not return errors if all params are valid" do
        post :slack, post_params
        expect(response).to be_success
      end

      it "should add gifs if all params are valid" do
        gifs_count = Gif.count
        post :slack, post_params
        expect(Gif.count).not_to eq(gifs_count)
      end

      it "should count votes when a gif is upvoted or downvoted" do
        post :slack, post_params

        gif = Lastgif.find(team_domain: team.domain, channel: "testing_reactif").first
        votes = team.teamgifs.find_by_gif_id(gif.gif_id).votes

        post_params[:text], post_params[:user_name] = "upvote", "user1"
        post :slack, post_params
        expect(team.teamgifs.find_by_gif_id(gif.gif_id).votes).not_to eq(votes)

        post_params[:text], post_params[:user_name], = "downvote", "user2"
        post :slack, post_params
        expect(team.teamgifs.find_by_gif_id(gif.gif_id).votes).to eq(votes)
      end

      it "should not allow users to vote more than once a week the same gif" do

        post :slack, post_params
        gif = Lastgif.find(team_domain: team.domain, channel: "testing_reactif").first
        votes = team.teamgifs.find_by_gif_id(gif.gif_id).votes

        post_params[:text], post_params[:user_name] = "upvote", "user1"
        post :slack, post_params
        expect(team.teamgifs.find_by_gif_id(gif.gif_id).votes).to eq(votes + 1)

        post :slack, post_params
        expect(team.teamgifs.find_by_gif_id(gif.gif_id).votes).to eq(votes + 1)

        post_params[:text] = "downvote"
        post :slack, post_params
        expect(team.teamgifs.find_by_gif_id(gif.gif_id).votes).to eq(votes + 1)

        Timecop.freeze(Time.now + 8.days)
        post :slack, post_params
        expect(team.teamgifs.find_by_gif_id(gif.gif_id).votes).to eq(votes)
      end
    end

  end
end