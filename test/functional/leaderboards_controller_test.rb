require 'test_helper'

class LeaderboardsControllerTest < ActionController::TestCase
  setup do
   # @leaderboard = leaderboards(:one)
  end

  test "should get valid leaderboard" do
    get :index ,{'id' => '3','month' => '2','year' => '2012'}
    assert_response :success
   
  end

 
end
