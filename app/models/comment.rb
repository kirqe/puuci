class Comment < ActiveRecord::Base
  validates :message, 
    presence: true,
    length: {minimum: 3, maximum: 500}, allow_blank: false

  belongs_to :commentable, polymorphic: true
  belongs_to :user
end