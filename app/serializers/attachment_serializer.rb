class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :url 

  # Некрасиво, увы =-( Но "сжевывать" след - тоже некрасиво.
  def url
    url = URI(root_url)
    url.path = object.file.url
    url.to_s
  end
end