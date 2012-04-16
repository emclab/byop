require 'spec_helper'

describe "Users" do
  describe "user login process" do
    it "should be success for a user to login" do
      user = Factory(:user)
      ul = Factory(:user_level, :user_id => user.id)
      test_sign_in(user)
      get '/user_menus'
      response.status.should be(200)
    end
  end
end
