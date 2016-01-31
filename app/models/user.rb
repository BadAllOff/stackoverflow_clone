class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username, presence: true, uniqueness: true, length: { maximum: 40, minimum: 1 },
            format: { with: /\A[a-zA-Z0-9]+(?: [a-zA-Z0-9]+)?\z/, message: 'only allows letters and 1 space between' }

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy

  def author_of?(object)
    id == object.user_id
  end

  def non_author_of?(object)
    !author_of?(object)
  end

end
