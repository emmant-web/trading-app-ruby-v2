require "test_helper"

class Users::TransactionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get users_transactions_new_url
    assert_response :success
  end
end
