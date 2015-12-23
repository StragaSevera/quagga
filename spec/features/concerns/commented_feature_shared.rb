require 'feature_helper'

shared_examples_for "commented as user" do |klass, block|
  scenario "User can make correct comments to the #{klass}", js: true do
    within block do
      click_link "оставить комментарий"
      within "##{klass}-#{@id}-comment-form" do
        fill_in "#{klass}-#{@id}_comment_body", with: "Commenting this!"
        click_button 'Отправить'
        wait_for_ajax
      end
    end
    expect(page).to have_content "Комментарий был создан!"
    expect(page).to have_content "Commenting this!"
  end

  scenario "User cannot make incorrect comments to the #{klass}", js: true do
    within block do
      click_link "оставить комментарий"
      within "##{klass}-#{@id}-comment-form" do
        click_button 'Отправить'
        wait_for_ajax
      end
    end
    expect(page).to have_content "Комментарий не может быть пустым"
    expect(page).not_to have_content "Комментарий был создан!"
  end
end

shared_examples_for "commented as guest" do |klass, block|
  scenario "User cannot make comments to the #{klass}" do
    within block do
      expect(page).not_to have_content "оставить комментарий"
    end
  end
end