require 'test_helper'

class DashboardsControllerTest < ActionController::TestCase
  test "should get financiero" do
    get :financiero
    assert_response :success
  end

  test "should get logistico" do
    get :logistico
    assert_response :success
  end

end
