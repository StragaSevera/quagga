class Attachment < ActiveRecord::Base
  mount_uploader :file, FileUploader

  belongs_to :question, foreign_key: :attachable_id
end
