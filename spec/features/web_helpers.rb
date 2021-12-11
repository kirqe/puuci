# frozen_string_literal: true

# require 'spec_helper'

def invalid_sign_up
  visit('/signup')
  fill_in 'user[username]', with: ''
  fill_in 'user[email]',    with: 'q@q.com'
  fill_in 'user[password]', with: '111111'
  click_button 'Submit'
end

def sign_up
  visit('/signup')
  fill_in 'user[username]', with: 'JohnD'
  fill_in 'user[email]',    with: 'q@q.com'
  fill_in 'user[password]', with: '111111'
  click_button 'Submit'
end

def invalid_log_in
  visit('/login')
  fill_in :email,    with: ''
  fill_in :password, with: '111111'
  click_button 'Submit'
end

def log_in
  visit('/login')
  fill_in :email,    with: 'q@q.com'
  fill_in :password, with: '111111'
  click_button 'Submit'
end

def create_new_project
  visit('/projects/new')
  fill_in :name, with: 'new project name'
  fill_in :note, with: 'new project note'
  click_button 'Submit'
end

def create_new_project_with_file
  visit('/projects/new')
  fill_in :name, with: 'new project name'
  fill_in :note, with: 'new project note'
  attach_file('ok', File.absolute_path('./spec/photo.jpg'))
  click_button 'Submit'
end

def create_new_issue_for(project); end

def create_new_comment_for(issue); end
