# frozen_string_literal: true

class ProjectsController < ApplicationController
  get '/projects', auth: %w[user admin] do
    @projects = Project.includes(issues: [:comments])
                       .not_draft
                       .active
                       .paginate(page: params[:page], per_page: 30)

    slim :'projects/index'
  end

  get '/projects/new', auth: %w[user admin] do
    @project = if user_has_projects_and_drafts?
                 current_user.projects.where('draft = true').first
               else
                 Project.create(user: current_user)
               end

    slim :'projects/new'
  end

  get '/projects/:id', auth: %w[user admin] do
    @project = Project.includes(issues: :comments).find(params[:id])
    @issues = @project.issues
                      .not_draft
                      .prioritized
                      .latest.paginate(page: params[:page], per_page: 30)
    slim :'projects/show'
  end

  get '/projects/:id/edit', auth: %w[user admin] do
    @project = Project.find(params[:id])
    authorize(@project)

    slim :'projects/edit'
  end

  patch '/projects/:id', auth: %w[user admin] do
    @project = Project.find(params[:id])
    authorize(@project)

    @project.name = params[:project][:name]
    @project.note = params[:project][:note]
    @project.priority = params[:project][:priority].to_i

    used_to_be_draft = @project.draft

    if @project.save
      if used_to_be_draft
        NotificationWorker.perform_async({
                                           user: current_user.username,
                                           message: { type: 'Project', resource: @project.to_json }
                                         })
      end

      reply_with_success(@project)
    else
      reply_with_error(@project)
    end
  end

  delete '/projects/:id', auth: %w[user admin] do |_id|
    @project = Project.find(params[:id])
    authorize(@project)

    @project.destroy

    flash :success, 'You have successfully deleted the project'
    redirect back
  end

  private

  def reply_with_success(project)
    {
      status: 'success',
      type: project.class.name,
      project: project
    }.to_json
  end

  def reply_with_error(project)
    {
      status: 'error',
      project: project,
      errors: project.errors
    }.to_json
  end

  def user_has_projects_and_drafts?
    current_user.projects.any? && current_user.projects.draft.first
  end
end
