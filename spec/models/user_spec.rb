require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'versioning', versioning: true do
    it 'reloads the original file name for "avatar" on reload (after reify)' do
      user = create_and_update_user_with(:avatar)

      expect(user.avatar.file.filename).to match /^image\.jpg$/
    end

    it 'reloads the original file name for "keeping_files_avatar" on reload (after reify)' do
      user = create_and_update_user_with(:keeping_files_avatar)

      expect(user.keeping_files_avatar.file.filename).to match /^image\.jpg$/
    end

    # Helper
    def create_and_update_user_with(field)
      # Create a first version with image.jpg
      user = User.create! field => File.open(File.expand_path('spec/support/dummy_files/image.jpg'))

      # Create a 2nd version with other_image.jpg
      user.update_attribute field, File.open(File.expand_path('spec/support/dummy_files/other_image.jpg'))
      user.save!

      # Reify version with image.jpg and reload
      user.versions.last.reify.save!
      user.reload

      user
    end
  end
end
