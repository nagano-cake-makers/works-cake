require "test_helper"

class Admin::SearchControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # en
  test "should get search" do
    get admin_search_search_url
    assert_response :success
  end
end
