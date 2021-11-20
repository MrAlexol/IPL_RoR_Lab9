require "test_helper"

class SequenceControllerTest < ActionDispatch::IntegrationTest
  test "should get input" do
    get sequence_input_url
    assert_response :success
  end

  test "should get view" do
    get sequence_view_url
    assert_response :success
  end
end
