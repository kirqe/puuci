# frozen_string_literal: true

module Dashboard
  class DashboardController < ApplicationController
    get '/dashboard', auth: ['admin'] do
      slim :"dashboard/index"
    end
  end
end
