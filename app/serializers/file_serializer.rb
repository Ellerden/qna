class FileSerializer < ActiveModel::Serializer
  attributes :url, :filename

  belongs_to :attachable
  belongs_to :author, class_name: 'User'

  def url
    Rails.application.routes.url_helpers.rails_blob_path(object, only_path: true)
  end

  def filename
    object.blob.filename
  end
end
