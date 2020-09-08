class Upload < ActiveRecord::Base
  after_destroy :remove_upload

  # belongs_to :project
  # belongs_to :issue

  belongs_to :uploadable, polymorphic: true

  private
    def remove_upload
      filename = "public/s/#{uploadable_id}/#{id}#{ext}"
      File.delete(filename) if File.exists?(filename)
    end
end


