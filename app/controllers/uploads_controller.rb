# frozen_string_literal: true

class UploadsController < ApplicationController
  post '/uploads', auth: %w[user admin] do
    # p params
    Dir.mkdir('public/s') unless Dir.exist?('public/s')

    dir = "public/s/#{params[:uploadable_id]}"
    Dir.mkdir(dir) unless Dir.exist?(dir)

    filename = params[:file][:filename].force_encoding('UTF-8')

    upload = Upload.new(
      filename: filename,
      ext: File.extname(filename),
      uploadable_id: params[:uploadable_id],
      uploadable_type: params[:uploadable_type]
    )

    if upload.save
      new_file_name = "#{upload.id}#{upload.ext}"
      File.rename(params[:file][:tempfile], new_file_name)
      FileUtils.mv(new_file_name, dir)

      reply_with_success(upload)
    else
      reply_with_error(upload)
    end
  end

  delete '/uploads/:id', auth: %w[user admin] do |_id|
    p 'THIS WAS CALLED'
    upload = Upload.find(params[:id])
    authorize(upload)

    upload.destroy
    flash :success, "You have successfully deleted <b>#{upload.filename}</b>"
    redirect back
  end

  private

  def reply_with_success(upload)
    {
      status: 'success',
      upload: upload,
      path: "/s/#{upload.uploadable_id}/#{upload.id}#{upload.ext}"
    }.to_json
  end

  def reply_with_error(upload)
    {
      status: 'error',
      upload: upload,
      errors: upload.errors
    }.to_json
  end
end
