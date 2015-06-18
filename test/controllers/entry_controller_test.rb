require 'test_helper'

class EntryControllerTest < ActionController::TestCase
  test "should get title:string" do
    get :title:string
    assert_response :success
  end

  test "should get body:text" do
    get :body:text
    assert_response :success
  end

  test "should get user:reference" do
    get :user:reference
    assert_response :success
  end

end
