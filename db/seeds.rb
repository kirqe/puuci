# frozen_string_literal: true

require File.expand_path('../config/environment', __dir__)

require 'faker'

users = []
projects = []
issues = []

User.create(username: 'admin', email: 'admin@admin.com', password: 'password', role: 'admin')

3.times do
  users << User.create(
    username: Faker::Internet.username,
    email: Faker::Internet.free_email,
    password: Faker::Internet.password,
    about: Faker::Lorem.sentence
  )
end

5.times do
  projects << Project.create(
    name: Faker::Lorem.sentence(word_count: rand(5..30)),
    note: Faker::Lorem.paragraph(sentence_count: rand(5..20)),
    draft: false,
    priority: rand(0..3),
    user: users.sample
  )
end

10.times do
  issues << Issue.create!(
    name: Faker::Lorem.sentence(word_count: rand(5..30)),
    note: Faker::Lorem.paragraph(sentence_count: rand(5..20)),
    priority: rand(0..3),
    project: projects.sample,
    draft: false,
    user: users.sample
  )
end

20.times do
  Comment.create!(
    message: Faker::Lorem.paragraph(sentence_count: rand(5..20)),
    commentable: issues.sample,
    user: users.sample
  )
end
