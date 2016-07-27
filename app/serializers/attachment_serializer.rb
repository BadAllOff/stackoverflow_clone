class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :url, :name, :created_at, :updated_at

  def url
    object.file.url
  end

  def name
    File.basename(object.file.url)
  end
end
