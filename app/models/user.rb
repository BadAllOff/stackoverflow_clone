class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username, presence: true, uniqueness: true, length: { maximum: 40, minimum: 1 },
            format: { with: /\A[a-zA-Z0-9]+(?: [a-zA-Z0-9]+)?\z/, message: 'only allows letters and 1 space between' }

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy

  def author_of?(object)
    id == object.user_id
  end

  def non_author_of?(object)
    !author_of?(object)
  end

  def vote_for(votable, value)
    vote = votes.new(votable: votable, value: value)
    vote.save
  end

  def voted_for?(votable)
    votes.where(votable: votable).any?
  end


  def unvote_for(votable)
    votes.where(votable: votable).delete_all
  end

end
