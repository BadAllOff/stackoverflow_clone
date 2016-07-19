class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment, only: [:destroy]
  authorize_resource

  def destroy
    @attachment.destroy if current_user.author_of?(@attachable)
    flash[:success] = 'Attachment successfully removed'
  end

  private

  def load_attachment
    @attachment = Attachment.includes(:attachable).find(params[:id])
  end

end
