class User < ActiveRecord::Base
  include Omniauthable
  include UserVotable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable,  omniauth_providers: [:github, :facebook, :twitter, :vkontakte]


  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authentications, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  validates :username, presence: true,
            uniqueness: { case_sensitive: false },
            length: { maximum: 40, minimum: 1 },
            format: {
                with: /\A[a-zA-Z0-9]+(?: [a-zA-Z0-9]+)?\z/,
                message: 'only allows letters and 1 space between'
            }

  def author_of?(object)
    id == object.user_id
  end

  def non_author_of?(object)
    !author_of?(object)
  end


  def subscribed?(object)
    subscriptions.where(question_id: object.id).first
  end

  def subscribe_to(object)
    subscriptions.find_or_create_by(question: object)
  end

end
