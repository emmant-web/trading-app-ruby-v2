require "test_helper"

class Users::PortfoliosControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get users_portfolios_show_url
    assert_response :success
  end
end
