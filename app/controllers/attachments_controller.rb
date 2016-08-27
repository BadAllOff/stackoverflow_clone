class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment, only: [:destroy]
  authorize_resource

  respond_to :js

  def destroy
    respond_with(@attachment.destroy)
  end

  private

  def load_attachment
    @attachment = Attachment.includes(:attachable).find(params[:id])
  end

end
