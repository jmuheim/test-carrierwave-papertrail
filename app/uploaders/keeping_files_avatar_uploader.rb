# encoding: utf-8

class KeepingFilesAvatarUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.id}/#{mounted_as}"
  end

  configure do |config|
    config.remove_previously_stored_files_after_update = false
  end
end
