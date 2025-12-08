require "test_helper"

class GlobalAnalysesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get global_analyses_show_url
    assert_response :success
  end
end
