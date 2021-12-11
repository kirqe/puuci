# frozen_string_literal: true

class ApplicationController < Sinatra::Base
  helpers WillPaginate::Sinatra::Helpers

  configure do
    # enable :sessions
    set :views, 'app/views'
    set :public_folder, 'public'
    set :files, 'public/files'
    set :unallowed_paths, ['.', '..']
    # set :no_auth_neededs, ['/signup', "/login", "/reset"]
    # set :session_secret, "40030143c5cf8e19d148f7897e184dbe69ce644d35aa5c15dde4456efdb8febb"
  end

  set(:auth) do |*roles|
    condition do
      if logged_in?
        unless roles.any? { |role| current_user.in_role? role }
          flash :error, 'Not authorized'
          redirect '/'
        end
      else
        env['warden'].authenticate!
      end
    end
  end

  error ActiveRecord::RecordNotFound do
    flash :error, "This page either doesn't exist or you don't have access to it"
    redirect '/'
  end

  helpers do
    def flash(key, value)
      session[:flash] = { key => value }
    end

    def warden
      env['warden']
    end

    def logged_in?
      warden.authenticated?
    end

    def current_user
      warden.user
    end

    def authorize(resource)
      if resource.class.name == 'User'
        unless resource == current_user
          flash :error, 'Not authorized'
          redirect '/'
        end
      elsif resource.class.name == 'Upload'
        unless resource.uploadable.user == current_user
          flash :error, 'Not authorized'
          redirect '/'
        end
      else
        unless current_user.is_admin? || resource.user == current_user
          flash :error, 'Not authorized'
          redirect '/'
        end
      end
    end

    def priority_color(priority)
      h = {
        low: 'prl',
        normal: 'prn',
        medium: 'prm',
        high: 'prh'
      }

      HashWithIndifferentAccess.new(h)[priority]
    end

    def marked(text)
      parser_options = {
        autolink: true,
        tables: true,
        fenced_code_blocks: true,
        disable_indented_code_blocks: true,
        underline: true,
        syntax_highlighter: :rouge,
        input: 'GFM'
      }

      text = Sanitize.fragment(text, Sanitize::Config::RELAXED)
      Kramdown::Document.new(text, parser_options).to_html
    end

    def file_icon(file)
      icon_name = 'far fa-file'
      formats = {
        %w[jpeg jpg png gif tiff psd bmp esp] => 'far fa-file-image',
        %w[pdf] => 'far fa-file-pdf',
        %w[doc docx] => 'far fa-file-word',
        %w[xls xlsx xlsm xml csv] => 'far fa-file-excel',
        %w[txt] => 'far fa-file-alt',
        %w[ppt pptx] => 'far fa-file-powerpoint',
        %w[mp3 wav] => 'far fa-file-audio',
        %w[mp4 mov] => 'far fa-file-video',
        %w[zip rar] => 'far fa-file-archive'
      }
      formats.each do |format_names, i_n|
        icon_name = i_n if format_names.include?(file.ext[1..-1].downcase)
      end
      icon_name
    end
  end
end
