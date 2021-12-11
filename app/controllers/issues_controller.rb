# frozen_string_literal: true

class IssuesController < ApplicationController
  get '/issues', auth: %w[user admin] do
    @issues = Issue.includes(:comments, :uploads)
                   .not_draft
                   .paginate(page: params[:page], per_page: 30)

    slim :'issues/index'
  end

  get '/projects/:id/issues/new', auth: %w[user admin] do
    @project = Project.find(params[:id])

    draft = @project.issues.draft.where('user_id = ?', current_user.id).first
    @issue = draft || @project.issues.create(user: current_user)

    slim :'issues/new'
  end

  get '/issues/:id', auth: %w[user admin] do
    @issue = Issue.find(params[:id])

    slim :'issues/show'
  end

  get '/issues/:id/edit', auth: %w[user admin] do
    @issue = Issue.find(params[:id])
    authorize(@issue)

    slim :'issues/edit'
  end

  patch '/issues/:id', auth: %w[user admin] do
    # fx ltr: id is taken from js but issue_id can also
    # be taken from hidden_field
    @issue = Issue.find(params[:id])
    authorize(@issue)

    @issue.name = params[:issue][:name]
    @issue.note = params[:issue][:note]
    @issue.priority = params[:issue][:priority].to_i
    @issue.user = current_user

    used_to_be_draft = @issue.draft

    if @issue.save
      if used_to_be_draft
        NotificationWorker.perform_async({
                                           user: current_user.username,
                                           message: { type: 'Issue', resource: @issue.to_json }
                                         })
      end

      reply_with_success(@issue)
    else
      reply_with_error(@issue)
    end
  end

  delete '/issues/:id', auth: %w[user admin] do |_id|
    @issue = Issue.find(params[:id])
    authorize(@issue)
    @issue.destroy

    flash :success, 'You have successfully deleted the issue'
    redirect back
  end

  private

  def reply_with_success(issue)
    {
      status: 'success',
      type: issue.class.name,
      issue: issue
    }.to_json
  end

  def reply_with_error(issue)
    {
      status: 'error',
      issue: issue,
      errors: issue.errors
    }.to_json
  end
end
