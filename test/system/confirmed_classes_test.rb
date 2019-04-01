require "application_system_test_case"

class ConfirmedClassesTest < ApplicationSystemTestCase
  setup do
    @confirmed_class = confirmed_classes(:one)
  end

  test "visiting the index" do
    visit confirmed_classes_url
    assert_selector "h1", text: "Confirmed Classes"
  end

  test "creating a Confirmed class" do
    visit confirmed_classes_url
    click_on "New Confirmed Class"

    fill_in "Preference", with: @confirmed_class.preference_id
    fill_in "Teaching assistant", with: @confirmed_class.teaching_assistant_id
    click_on "Create Confirmed class"

    assert_text "Confirmed class was successfully created"
    click_on "Back"
  end

  test "updating a Confirmed class" do
    visit confirmed_classes_url
    click_on "Edit", match: :first

    fill_in "Preference", with: @confirmed_class.preference_id
    fill_in "Teaching assistant", with: @confirmed_class.teaching_assistant_id
    click_on "Update Confirmed class"

    assert_text "Confirmed class was successfully updated"
    click_on "Back"
  end

  test "destroying a Confirmed class" do
    visit confirmed_classes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Confirmed class was successfully destroyed"
  end
end
