class Api::V1::ProfilesController < Api::V1::BaseController

  def me
    respond_to do |format|
      format.json do
        render json: current_resource_owner, status: 200
      end
    end
  end

  def index
    respond_to do |format|
      format.json do
        users =  User.where.not(id: current_resource_owner)
        render json: users, status: 200
      end
    end
  end


end