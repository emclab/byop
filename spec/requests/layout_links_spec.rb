require 'spec_helper'

describe "LayoutLinks" do
  describe "GET /signin or signout" do
    it "should works for /signin!" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get '/signin'
      response.status.should be(200)
    end
    
    it "should works for /signout!" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get '/signout'
      response.status.should be(200)
    end    
  end
end
