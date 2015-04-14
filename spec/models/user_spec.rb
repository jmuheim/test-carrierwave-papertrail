require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'versioning', versioning: true do
    context 'reloading the model after reify' do
      it 'sets "avatar" to the original value' do
        user = create_and_update_user_with(:avatar)

        user.reload # Reload!
        expect(user.avatar.file.filename).to eq 'image.jpg'
      end

      it 'sets "keeping_files_avatar" to the original value' do
        pending 'See StackOverflow'
        user = create_and_update_user_with(:keeping_files_avatar)

        user.reload # Reload!
        expect(user.keeping_files_avatar.file.filename).to eq 'image.jpg'
      end
    end

    context 'querying the model from the database after reify' do
      it 'sets "avatar" to the original value' do
        user = create_and_update_user_with(:avatar)

        user = User.find user.id # Query db!
        expect(user.avatar.file.filename).to eq 'image.jpg'
      end

      it 'sets "keeping_files_avatar" to the original value' do
        user = create_and_update_user_with(:keeping_files_avatar)

        user = User.find user.id # Query db!
        expect(user.keeping_files_avatar.file.filename).to eq 'image.jpg'
      end
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

      user
    end
  end
end
