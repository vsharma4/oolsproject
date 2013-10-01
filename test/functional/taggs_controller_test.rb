require 'test_helper'

class TaggsControllerTest < ActionController::TestCase
  setup do
    @tagg = taggs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:taggs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tagg" do
    assert_difference('Tagg.count') do
      post :create, tagg: { name: @tagg.name }
    end

    assert_redirected_to tagg_path(assigns(:tagg))
  end

  test "should show tagg" do
    get :show, id: @tagg
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tagg
    assert_response :success
  end

  test "should update tagg" do
    put :update, id: @tagg, tagg: { name: @tagg.name }
    assert_redirected_to tagg_path(assigns(:tagg))
  end

  test "should destroy tagg" do
    assert_difference('Tagg.count', -1) do
      delete :destroy, id: @tagg
    end

    assert_redirected_to taggs_path
  end
end
