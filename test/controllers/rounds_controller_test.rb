require 'test_helper'

class RoundsControllerTest < ActionController::TestCase
  setup do
    @round = rounds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rounds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create round" do
    assert_difference('Round.count') do
      post :create, round: { competition_id: @round.competition_id, course_id: @round.course_id, division: @round.division, score: @round.score, tee_id: @round.tee_id, tour_part_id: @round.tour_part_id, user_id: @round.user_id }
    end

    assert_redirected_to round_path(assigns(:round))
  end

  test "should show round" do
    get :show, id: @round
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @round
    assert_response :success
  end

  test "should update round" do
    patch :update, id: @round, round: { competition_id: @round.competition_id, course_id: @round.course_id, division: @round.division, score: @round.score, tee_id: @round.tee_id, tour_part_id: @round.tour_part_id, user_id: @round.user_id }
    assert_redirected_to round_path(assigns(:round))
  end

  test "should destroy round" do
    assert_difference('Round.count', -1) do
      delete :destroy, id: @round
    end

    assert_redirected_to rounds_path
  end
end
