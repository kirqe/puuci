require_rel "./web_helpers.rb"
require "spec_helper"

RSpec.describe "Logging in and out", :type => :feature do
  feature "Log in" do
    before { User.create!(email: "q@q.com", username: "JohnD", password: "111111") }   
  
    scenario "user logges-in into their account with valid credentials" do
      visit "/login"
      fill_in :email, with: 'q@q.com'
      fill_in :password, with: '111111'
      click_button 'Submit'
      expect(page).to have_selector 'h1', text: 'JohnD'
    end

    scenario "user logges-in into their account with valid credentials" do
      visit "/login"
      fill_in :email, with: 'q@q.com'
      fill_in :password, with: 'wrong'
      click_button 'Submit'
      expect(page.current_path).to eq "/login"
    end
  end

end
