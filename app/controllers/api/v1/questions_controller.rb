class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :doorkeeper_authorize! # Require access token for all actions

  def index
    render nothing: true
  end

end