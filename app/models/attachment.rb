# == Schema Information
#
# Table name: attachments
#
#  id              :integer          not null, primary key
#  file            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  attachable_id   :integer
#  attachable_type :string
#

class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true, touch: true

  mount_uploader :file, FileUploader

  validates :file, presence: true
end
