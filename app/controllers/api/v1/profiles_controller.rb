class Api::V1::ProfilesController < ApplicationController
  before_action :doorkeeper_authorize! # Require access token for all actions

  def me
    respond_to do |format|
      format.json do
        render json: current_resource_owner, status: 200
      end
    end
  end

  protected

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end