require 'rails_helper'

describe SearchController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: '/search').to route_to('search#index')
    end

    it "routes to #show" do
      expect(get: '/search/found/').to route_to('search#show')
    end

    it "routes to #slack" do
      expect(get: '/search/slack').to route_to('search#slack')
    end
  end
end
