class Project < ActiveRecord::Base
  after_destroy :remove_uploads_folder
  before_update :check_if_draft

  validates :name, 
    presence: true,
    length: {minimum: 5, maximum: 500}, allow_blank: false,
    on: :update

  validates :note, 
    presence: true,
    length: {minimum: 5, maximum: 5000}, allow_blank: false,
    on: :update

  has_many :uploads, as: :uploadable
  has_many :issues, dependent: :destroy
  belongs_to :user

  scope :active, -> { where("active = ?", true) }
  scope :draft, -> { where("draft = ?", true) }
  scope :not_draft, -> { where("draft = ?", false) }
  scope :latest, -> { order("updated_at DESC") }
  scope :prioritized, -> { order("priority DESC") }
  scope :within, -> (hours) { where(updated_at: hours.hours.ago..DateTime.now) }
  
  enum priority: {
    low: 0,
    normal: 1,
    medium: 2,
    high: 3
  }

  private
    def remove_uploads_folder
      dir = "public/s/#{id}"
      FileUtils.remove_dir(dir) if Dir.exists?(dir)
      # FileUtils.rm_rf("public/s/#{self.id}") if Dir.exists?("public/s/#{self.id}")
    end

    def check_if_draft
      self.draft = false if valid?
    end
end