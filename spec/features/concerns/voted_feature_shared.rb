require 'feature_helper'

shared_examples_for "voted as correct user" do |klass|
  scenario 'User votes for answer', js: true do
    within "##{klass}-block" do
      within '.stats-block' do
        expect(page).to have_content "0"

        click_link '>'
        wait_for_ajax
        expect(page).not_to have_content "0"
        expect(page).to have_content "1"

        click_link '<'
        wait_for_ajax
        expect(page).not_to have_content "1"
        expect(page).to have_content "0"
      end
    end
  end

  scenario 'User cannot vote twice in one direction', js: true do
    within "##{klass}-block" do
      within '.stats-block' do
        click_link '>'
        wait_for_ajax
        click_link '>'
        wait_for_ajax
        expect(page).not_to have_content "2"
        expect(page).to have_content "1"

        click_link '<'
        wait_for_ajax
        expect(page).not_to have_content "1"
        expect(page).to have_content "0"

        click_link '<'
        wait_for_ajax
        expect(page).not_to have_content "0"
        expect(page).to have_content "-1"

        click_link '<'
        wait_for_ajax
        expect(page).not_to have_content "-2"
        expect(page).to have_content "-1"   
      end
    end
  end  
end

shared_examples_for "voted as incorrect user" do |klass|
  scenario 'User cannot vote incorrectly', js: true do
    within "##{klass}-block" do
      within '.stats-block' do
        expect(page).to have_content '<'
        expect(page).not_to have_link '<'

        expect(page).to have_content '>'
        expect(page).not_to have_link '>'
      end
    end
  end  
end
