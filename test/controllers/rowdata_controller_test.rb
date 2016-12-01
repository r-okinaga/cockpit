require 'test_helper'

class RowdataControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get rowdata_index_url
    assert_response :success
  end

end
