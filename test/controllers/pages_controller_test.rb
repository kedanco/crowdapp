require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pages_index_url
    assert_response :success
  end

  test "should get home" do
    get pages_home_url
    assert_response :success
  end

  test "should get settings" do
    get pages_settings_url
    assert_response :success
  end

  test "should get faq" do
    get pages_faq_url
    assert_response :success
  end

end
