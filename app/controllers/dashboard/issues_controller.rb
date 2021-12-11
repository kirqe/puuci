# frozen_string_literal: true

module Dashboard
  class IssuesController < Dashboard::DashboardController
    get '/dashboard/issues', auth: ['admin'] do
      slim :"dashboard/issues/index"
    end
  end
end
