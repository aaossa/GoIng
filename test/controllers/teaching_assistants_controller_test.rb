require 'test_helper'

class TeachingAssistantsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @teaching_assistant = teaching_assistants(:one)
  end

  test "should get index" do
    get teaching_assistants_url
    assert_response :success
  end

  test "should get new" do
    get new_teaching_assistant_url
    assert_response :success
  end

  test "should create teaching_assistant" do
    assert_difference('TeachingAssistant.count') do
      post teaching_assistants_url, params: { teaching_assistant: { email: @teaching_assistant.email, name: @teaching_assistant.name, phone_number: @teaching_assistant.phone_number } }
    end

    assert_redirected_to teaching_assistant_url(TeachingAssistant.last)
  end

  test "should show teaching_assistant" do
    get teaching_assistant_url(@teaching_assistant)
    assert_response :success
  end

  test "should get edit" do
    get edit_teaching_assistant_url(@teaching_assistant)
    assert_response :success
  end

  test "should update teaching_assistant" do
    patch teaching_assistant_url(@teaching_assistant), params: { teaching_assistant: { email: @teaching_assistant.email, name: @teaching_assistant.name, phone_number: @teaching_assistant.phone_number } }
    assert_redirected_to teaching_assistant_url(@teaching_assistant)
  end

  test "should destroy teaching_assistant" do
    assert_difference('TeachingAssistant.count', -1) do
      delete teaching_assistant_url(@teaching_assistant)
    end

    assert_redirected_to teaching_assistants_url
  end
end
