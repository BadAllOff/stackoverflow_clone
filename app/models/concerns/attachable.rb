module Attachable
  extend ActiveSupport::Concern
  included do
    accepts_nested_attributes_for :attachments, reject_if: ->(a) { a[:file].blank? }, allow_destroy: true
    has_many :attachments, as: :attachable, dependent: :destroy
  end
end
