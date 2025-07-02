require 'rails_helper'

RSpec.describe "WelcomePages", type: :request do
  describe "GET /" do
    it "render page" do
      get root_path
      expect(response.body).to include("DailyDone")
    end
  end
end
