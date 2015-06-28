require 'timecop'
require 'rails_helper'

describe SearchController do
  describe "POST #slack", vcr: true do
    
    let(:team) { FactoryGirl.create(:team) }
    let(:channel_name) { "testing_reactif" }
    let!(:post_params) { post_params = {text: "dude", channel_name: channel_name, user_name: Faker::Internet.user_name, team_domain: team.domain}}

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

      context "when voting on the last gif" do
        before { post :slack, post_params }
        let(:last_gif) { Lastgif.find(team_domain: team.domain, channel: channel_name).first }
        let(:teamgif) { team.teamgifs.find_by_gif_id(last_gif.gif_id) }

        it "upvoting should increment votes by 1" do
          post_params[:text] = "upvote"
          expect{post :slack, post_params}.to change{teamgif.reload.votes}.by(1)
        end

        it "downvoting should increment votes by -1" do
          post_params[:text] = "downvote"
          expect{post :slack, post_params}.to change{teamgif.reload.votes}.by(-1)
        end

        it "the same user should not be able to vote more than once a week on the same gif" do
          post_params[:text] = "upvote"
          expect{post :slack, post_params}.to change{teamgif.reload.votes}.by(1)
          expect{post :slack, post_params}.not_to change{teamgif.reload.votes}
          post_params[:text] = "downvote"
          expect{post :slack, post_params}.not_to change{teamgif.reload.votes}
          Timecop.freeze(Time.now + 8.days)
          expect{post :slack, post_params}.to change{teamgif.reload.votes}.by(-1)
        end
      end
    end

    context "should work more than one team belong to the same user" do
      let(:user) { FactoryGirl.create(:user, email: Faker::Internet.email) }
      let(:team1) { FactoryGirl.create(:team, user: user, webhook: "http://webook1.com/") }
      let(:team2) { FactoryGirl.create(:team, user: user, webhook: "http://webook2.com/") }

      it "it should query properly for the first team of the user" do
        post_params[:team_domain] = team1.domain
        post :slack, post_params
        expect(response).to be_success
      end

      it "it should query properly for any other team of the same user" do
        post_params[:team_domain] = team2.domain
        post :slack, post_params
        expect(response).to be_success
      end
    end
  end
end