require "application_system_test_case"

class TeachingAssistantsTest < ApplicationSystemTestCase
  setup do
    @teaching_assistant = teaching_assistants(:one)
  end

  test "visiting the index" do
    visit teaching_assistants_url
    assert_selector "h1", text: "Teaching Assistants"
  end

  test "creating a Teaching assistant" do
    visit teaching_assistants_url
    click_on "New Teaching Assistant"

    fill_in "Email", with: @teaching_assistant.email
    fill_in "Name", with: @teaching_assistant.name
    fill_in "Phone number", with: @teaching_assistant.phone_number
    click_on "Create Teaching assistant"

    assert_text "Teaching assistant was successfully created"
    click_on "Back"
  end

  test "updating a Teaching assistant" do
    visit teaching_assistants_url
    click_on "Edit", match: :first

    fill_in "Email", with: @teaching_assistant.email
    fill_in "Name", with: @teaching_assistant.name
    fill_in "Phone number", with: @teaching_assistant.phone_number
    click_on "Update Teaching assistant"

    assert_text "Teaching assistant was successfully updated"
    click_on "Back"
  end

  test "destroying a Teaching assistant" do
    visit teaching_assistants_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Teaching assistant was successfully destroyed"
  end
end
