class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  before_action :load_attachment, only: [:destroy]
  before_action :load_attachable, only: [:destroy]

  def destroy
    @attachment.destroy if current_user.author_of?(@attachable)
    flash[:success] = 'Attachment successfully removed'
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end

  def load_attachable
    @attachable = @attachment.attachable
  end

end
