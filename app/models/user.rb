class User < ActiveRecord::Base
  has_paper_trail only: [:name, :email, :avatar]
  mount_uploader :avatar, AvatarUploader
end
