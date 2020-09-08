class HomeController < ApplicationController
  get '/', :auth => ["user", "admin"] do    
    @projects = Project.not_draft.active.within(24)
    @issues = Issue.not_draft.within(24)
    @resources = (@projects + @issues).paginate(page: params[:page], per_page: 30)

    slim :'home/index'
  end
end