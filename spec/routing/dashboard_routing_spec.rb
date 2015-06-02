require 'rails_helper'

describe DashboardController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: '/dashboard').to route_to('dashboard#index')
    end

    it "routes to #show" do
      expect(get: '/dashboard/settings/').to route_to('dashboard#settings')
    end

    it "routes to #api" do
      expect(get: '/dashboard/api').to route_to('dashboard#api')
    end

    it "routes to #get_token" do
      expect(post: '/dashboard/get_token').to route_to('dashboard#get_token')
    end
  end
end
