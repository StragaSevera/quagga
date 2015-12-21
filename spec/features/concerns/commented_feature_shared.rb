require 'feature_helper'

shared_examples_for "commented as user" do |klass|
  scenario "User can make correct comments to the #{klass}", js: true do
    within "##{klass}-block" do
      click_link "комментировать"
      within '.comments-subblock' do
        fill_in 'комментарий', with: "Commenting this!"
        click_button 'Отправить'
      end
      expect(page).to have_content "Комментарий был создан!"
      expect(page).to have_content "Commenting this!"
    end
  end

  scenario "User cannot make incorrect comments to the #{klass}", js: true do
    within "##{klass}-block" do
      click_link "комментировать"
      within '.comments-subblock' do
        click_button 'Отправить'
      end
      expect(page).to have_content "Комментарий не может быть пустым"
      expect(page).not_to have_content "Комментарий был создан!"
    end
  end
end

shared_examples_for "commented as guest" do |klass|
  scenario "User cannot make comments to the #{klass}" do
    within "##{klass}-block" do
      expect(page).not_to have_content "комментировать"
    end
  end
end