require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'versioning', versioning: true do
    context 'avatar' do
      it 'reloads the original file name for "avatar" on reload (after reify)' do
        user = User.create! name:   'donald',
                            avatar: File.open(File.expand_path('spec/support/dummy_files/image.jpg'))

        user.update_attributes! avatar: File.open(File.expand_path('spec/support/dummy_files/other_image.jpg'))
        user.versions.last.reify.save
        user.reload

        expect(user.avatar.file.filename).to match /^image\.jpg$/
      end
    end

    context 'keeping files avatar' do
      it 'reloads the original file name for "keeping_files_avatar" on reload (after reify)' do
        user = User.create! name:                 'donald',
                            keeping_files_avatar: File.open(File.expand_path('spec/support/dummy_files/image.jpg'))

        user.update_attributes! keeping_files_avatar: File.open(File.expand_path('spec/support/dummy_files/other_image.jpg'))
        user.versions.last.reify.save
        user.reload

        expect(user.keeping_files_avatar.file.filename).to match /^image\.jpg$/
      end
    end
  end
end
