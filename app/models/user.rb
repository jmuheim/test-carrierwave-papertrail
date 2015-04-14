class User < ActiveRecord::Base
  has_paper_trail only: [:name, :avatar, :keeping_files_avatar]
  mount_uploader :avatar, AvatarUploader
  mount_uploader :keeping_files_avatar, KeepingFilesAvatarUploader
end
