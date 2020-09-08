require_rel "./web_helpers.rb"
require "spec_helper"

RSpec.describe "Sign up", :type => :feature do
  feature "Sign up" do
    # before { User.create!(email: "q@q.com", username: "JohnD", password: "111111") } 
    
    scenario "user enters valid credentials" do
      visit "/signup"
      fill_in :username, with: 'JohnD'
      fill_in :email, with: 'q@q.com'
      fill_in :password, with: '111111'
      click_button 'Submit'
      # expect(page).to have_selector 'h1', text: 'Log in'
      expect(page).to have_current_path("/login")
    end

    scenario "user enters invalid credentials" do
      visit "/signup"
      fill_in :username, with: ''
      fill_in :email, with: 'q@q.com'
      fill_in :password, with: '111111'
      click_button 'Submit'
      # expect(page).to have_selector 'h1', text: 'Log in'
      expect(page).to have_current_path("/signup")
    end
  end

end
