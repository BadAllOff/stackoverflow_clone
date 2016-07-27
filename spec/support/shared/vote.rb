shared_examples_for 'Votable' do |object_name|

  describe 'PATCH #upvote' do
    context "votes up for his own #{object_name}" do
      before { sign_in(user) }
      it '- does not keep the vote' do
        expect { patch :upvote, id: object, format: :json }.to_not change(object.votes.upvotes, :count)
      end
    end

    context "votes up for other user's #{object_name}" do
      before { sign_in(another_user) }
      it "- keep's the vote" do
        expect { patch :upvote, id: object, format: :json }.to change(object.votes.upvotes, :count).by 1
      end

      it "- can't vote twice" do
        patch :upvote, id: object, format: :json
        expect { patch :upvote, id: object, format: :json }.to_not change(object.votes.upvotes, :count)
      end
    end
  end


  describe 'PATCH #downvote' do
    context "votes down for his own #{object_name}" do
      before { sign_in(user) }
      it '- does not keep the vote' do
        expect { patch :downvote, id: object, format: :json }.to_not change(object.votes.downvotes, :count)
      end
    end

    context "votes down for other user's #{object_name}" do
      before { sign_in(another_user) }
      it "- keep's the vote" do
        expect { patch :downvote, id: object, format: :json }.to change(object.votes.downvotes, :count).by 1
      end

      it "- can't downvote twice" do
        patch :downvote, id: object, format: :json
        expect { patch :downvote, id: object, format: :json }.to_not change(object.votes.upvotes, :count)
      end
    end
  end


  describe 'PATCH #unvote' do
    before do
      sign_in(another_user)
      patch :upvote, id: object, format: :json
    end

    it "- deletes vote for votable object (#{object_name})" do
      expect { patch :unvote, id: object, format: :json }.to change(object.votes, :count).by(-1)
    end

    it "- if not voted, can\'t delete vote for votable object (#{object_name})" do
      patch :unvote, id: object, format: :json
      expect { patch :unvote, id: object, format: :json }.to_not change(object.votes, :count)
    end

  end

end
