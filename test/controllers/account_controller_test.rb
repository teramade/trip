require 'test_helper'

class AccountControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get account_edit_url
    assert_response :success
  end

end
