class Api::V1::ApplicationController < ApplicationController
  before_action :authenticate_api_v1_user!

  def current_user
    current_api_v1_user
  end
end
