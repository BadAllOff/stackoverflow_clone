class Api::V1::ProfilesController < Api::V1::BaseController

  respond_to :json
  def me
    respond_with current_resource_owner
  end

  def index
    respond_with User.where.not(id: current_resource_owner)
  end


end