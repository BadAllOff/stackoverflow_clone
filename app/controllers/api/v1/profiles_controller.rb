class Api::V1::ProfilesController < ApplicationController
  before_action :doorkeeper_authorize! # Require access token for all actions

  def me
    render nothing: true
  end
end