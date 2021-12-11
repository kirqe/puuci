# frozen_string_literal: true

class Issue < ActiveRecord::Base
  before_update :check_if_draft

  validates :name,
            presence: true,
            uniqueness: { scope: :project_id },
            length: { minimum: 3, maximum: 500 }, allow_blank: false,
            on: :update

  validates :note,
            presence: true,
            length: { minimum: 3, maximum: 1000 }, allow_blank: false,
            on: :update

  has_many :uploads, as: :uploadable
  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :project
  belongs_to :user

  scope :active, -> { where('active = ?', true) }
  scope :draft, -> { where('draft = ?', true) }
  scope :not_draft, -> { where('draft = ?', false) }
  scope :latest, -> { order('updated_at DESC') }
  scope :prioritized, -> { order('priority DESC') }
  scope :within, ->(hours) { where(updated_at: hours.hours.ago..DateTime.now) }

  enum priority: {
    low: 0,
    normal: 1,
    medium: 2,
    high: 3
  }

  private

  def check_if_draft
    self.draft = false if valid?
  end
end
