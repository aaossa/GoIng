require 'test_helper'

class ConfirmedClassesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @confirmed_class = confirmed_classes(:one)
  end

  test "should get index" do
    get confirmed_classes_url
    assert_response :success
  end

  test "should get new" do
    get new_confirmed_class_url
    assert_response :success
  end

  test "should create confirmed_class" do
    assert_difference('ConfirmedClass.count') do
      post confirmed_classes_url, params: { confirmed_class: { preference_id: @confirmed_class.preference_id, teaching_assistant_id: @confirmed_class.teaching_assistant_id } }
    end

    assert_redirected_to confirmed_class_url(ConfirmedClass.last)
  end

  test "should show confirmed_class" do
    get confirmed_class_url(@confirmed_class)
    assert_response :success
  end

  test "should get edit" do
    get edit_confirmed_class_url(@confirmed_class)
    assert_response :success
  end

  test "should update confirmed_class" do
    patch confirmed_class_url(@confirmed_class), params: { confirmed_class: { preference_id: @confirmed_class.preference_id, teaching_assistant_id: @confirmed_class.teaching_assistant_id } }
    assert_redirected_to confirmed_class_url(@confirmed_class)
  end

  test "should destroy confirmed_class" do
    assert_difference('ConfirmedClass.count', -1) do
      delete confirmed_class_url(@confirmed_class)
    end

    assert_redirected_to confirmed_classes_url
  end
end
