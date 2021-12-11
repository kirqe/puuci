# frozen_string_literal: true

class SearchController < ApplicationController
  # td ref
  post '/search', auth: %w[user admin] do
    if !params[:q].empty?
      @q = params[:q]
      @type, @term = params[:q].split(':').map(&:strip)

      if @type && @term
        if @type.downcase == 'issue'
          @issues = Issue.where('name LIKE ? OR note LIKE ?', "%#{@term}%", "%#{@term}%")
                         .not_draft
                         .paginate(page: params[:page], per_page: 30)

          slim :'issues/index'
        elsif @type.downcase == 'project'
          @projects = Project.where('name LIKE ? OR note LIKE ?', "%#{@term}%", "%#{@term}%")
                             .not_draft
                             .active
                             .paginate(page: params[:page], per_page: 30)

          slim :'projects/index'
        end
      else
        # refactor to using tags if it's one line query
        flash :info, "Nothing's found"
        redirect '/'
      end
    else
      flash :info, "Nothing's found"
      redirect '/'
    end
  end
end
