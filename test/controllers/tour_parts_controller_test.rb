require 'test_helper'

class TourPartsControllerTest < ActionController::TestCase
  setup do
    @tour_part = tour_parts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tour_parts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tour_part" do
    assert_difference('TourPart.count') do
      post :create, tour_part: { competition_id: @tour_part.competition_id, content: @tour_part.content, course_id: @tour_part.course_id, name: @tour_part.name, tee_id: @tour_part.tee_id }
    end

    assert_redirected_to tour_part_path(assigns(:tour_part))
  end

  test "should show tour_part" do
    get :show, id: @tour_part
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tour_part
    assert_response :success
  end

  test "should update tour_part" do
    patch :update, id: @tour_part, tour_part: { competition_id: @tour_part.competition_id, content: @tour_part.content, course_id: @tour_part.course_id, name: @tour_part.name, tee_id: @tour_part.tee_id }
    assert_redirected_to tour_part_path(assigns(:tour_part))
  end

  test "should destroy tour_part" do
    assert_difference('TourPart.count', -1) do
      delete :destroy, id: @tour_part
    end

    assert_redirected_to tour_parts_path
  end
end
