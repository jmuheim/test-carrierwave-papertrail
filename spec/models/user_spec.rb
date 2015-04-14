require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'versioning', versioning: true do
    context 'reloading the model after reify' do
      it 'sets "avatar" to the original value' do
        user = create_and_update_user_with(:avatar)

        user.reload # Reload!
        expect(user.name).to eq 'original-name'
        expect(user.avatar.file.filename).to eq 'original-image.jpg'
      end

      it 'sets "keeping_files_avatar" to the original value' do
        pending 'See StackOverflow'
        user = create_and_update_user_with(:keeping_files_avatar)

        user.reload # Reload!
        expect(user.name).to eq 'original-name' # This normal string field is correctly reloaded
        expect(user.keeping_files_avatar.file.filename).to eq 'original-image.jpg' # This upload field isn'! <<<FAILING LINE>>>!
      end
    end

    context 'querying the model from the database after reify' do
      it 'sets "avatar" to the original value' do
        user = create_and_update_user_with(:avatar)

        user = User.find user.id # Query db!
        expect(user.name).to eq 'original-name'
        expect(user.avatar.file.filename).to eq 'original-image.jpg'
      end

      it 'sets "keeping_files_avatar" to the original value' do
        user = create_and_update_user_with(:keeping_files_avatar)

        user = User.find user.id # Query db!
        expect(user.name).to eq 'original-name'
        expect(user.keeping_files_avatar.file.filename).to eq 'original-image.jpg'
      end
    end

    # Helper
    def create_and_update_user_with(field)
      # Create a first version with original-name and original-image.jpg
      user = User.create! name: 'original-name',
                          field => File.open(File.expand_path('spec/support/dummy_files/original-image.jpg'))

      # Create a 2nd version with new-name and new-image.jpg
      user.update_attributes! name: 'new-name',
                              field => File.open(File.expand_path('spec/support/dummy_files/new-image.jpg'))

      # Reify version (user.previous_version.save! would also work) and reload
      user.versions.last.reify.save!

      user
    end
  end
end
