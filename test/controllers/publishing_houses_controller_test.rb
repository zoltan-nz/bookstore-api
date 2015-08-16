require 'test_helper'

class PublishingHousesControllerTest < ActionController::TestCase
  setup do
    @publishing_house = publishing_houses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:publishing_houses)
  end

  test "should create publishing_house" do
    assert_difference('PublishingHouse.count') do
      post :create, publishing_house: { discount: @publishing_house.discount, name: @publishing_house.name }
    end

    assert_response 201
  end

  test "should show publishing_house" do
    get :show, id: @publishing_house
    assert_response :success
  end

  test "should update publishing_house" do
    put :update, id: @publishing_house, publishing_house: { discount: @publishing_house.discount, name: @publishing_house.name }
    assert_response 204
  end

  test "should destroy publishing_house" do
    assert_difference('PublishingHouse.count', -1) do
      delete :destroy, id: @publishing_house
    end

    assert_response 204
  end
end
