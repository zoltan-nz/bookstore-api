require 'test_helper'

class AuthorsControllerTest < ActionController::TestCase
  setup do
    @author = authors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:authors)
  end

  test "should create author" do
    assert_difference('Author.count') do
      post :create, author: { name: @author.name }
    end

    assert_response 201
  end

  test "should show author" do
    get :show, id: @author
    assert_response :success
  end

  test "should update author" do
    put :update, id: @author, author: { name: @author.name }
    assert_response 204
  end

  test "should destroy author" do
    assert_difference('Author.count', -1) do
      delete :destroy, id: @author
    end

    assert_response 204
  end
end
