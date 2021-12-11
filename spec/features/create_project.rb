# frozen_string_literal: true
# require_rel "./web_helpers.rb"
# require "spec_helper"

# RSpec.describe "Create new project", :type => :feature do
#   feature "Create new project" do
#     given!(:user) { User.create!(email: "q@q.com", username: "JohnD", password: "111111") }
#     # before { @current_user = User.create!(email: "q@q.com", username: "JohnD", password: "111111") }

#     scenario "creates new project" do
#       page.set_rack_session(user_id: user.id)
#       visit "/projects/new"
#       # fill_in :email, with: 'q@q.com'
#       # fill_in :password, with: '111111'
#       # click_button 'Submit'
#       # page.set_rack_session(user_id: @current_user.id)

#       # visit '/projects/new'
#       # fill_in :name, with: 'new project name'
#       # fill_in :note, with: 'new project note'
#       # attach_file 'ok', File.absolute_path('./spec/photo.jpg')
#       # click_button 'Submit'

#       # # create_new_project_with_file
#       # expect(page).to have_selector 'h1', text: 'new project name'
#     end

#   end

# end
