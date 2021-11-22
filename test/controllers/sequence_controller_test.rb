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

  test 'should return json respond' do
    get "#{sequence_view_url}.json", xhr: true, params: { values: '10  1 2 3 4  3 4 5 4   0' }

    assert_equal '[{"name":"result","type":"String","value":"1 2 3 4"},{"name":"subs","type":"Array","value":["1 2 3 4","3 4 5"]},{"name":"error","type":"NilClass","value":null}]', @response.body
    assert_equal 'application/json', @response.media_type
    resp = JSON.parse(@response.body)
    resp.map do |obj|
      case obj[:name]
      when 'result'
        assert_equal obj[:type], 'String'
        assert_equal obj[:value], '1 2 3 4'
      when 'error'
        assert_equal obj[:type], 'NilClass'
        assert_nil obj[:value]
      when 'subs'
        assert_equal obj[:type], 'Array'
        assert_includes obj[:value], '1 2 3 4'
        assert_includes obj[:value], '3 4 5'
      end
    end
    puts '=Objects='
    puts resp
  end
end
