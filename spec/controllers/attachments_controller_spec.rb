require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:attachment) { create(:attachment, attachable: question) }

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      sign_in_user
      before { attachment }

      context 'operates with his own attachment' do
        let!(:question) { create(:question, user: @user) }
        let!(:attachment) { create(:attachment, attachable: question) }

        it '- deletes attachment' do
          expect {delete :destroy, id: attachment, format: :js }.to change(question.attachments, :count).by(-1)
        end

        it '- render destroy template' do
          delete :destroy, id: attachment, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'operates with other users attachments' do
        sign_in_another_user

        it '- does not deletes attachment' do
          expect {delete :destroy, id: attachment, format: :js }.to_not change(Attachment, :count)
        end
      end
    end

    context 'Non-authenticated user' do
      before { attachment }

      it '- unauthorized to delete attachment' do
        delete :destroy, id: attachment, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end

  end

end
