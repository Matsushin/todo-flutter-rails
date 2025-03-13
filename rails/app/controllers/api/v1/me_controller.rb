class Api::V1::MeController < Api::V1::ApplicationController
  def show
    render json: current_user
  end
end