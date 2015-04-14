require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'versioning', versioning: true do
    before do
      @user = User.create! name:                 'donald',
                           avatar:               File.open(File.expand_path('spec/support/dummy_files/image.jpg')),
                           keeping_files_avatar: File.open(File.expand_path('spec/support/dummy_files/image.jpg'))
    end

    it 'restores the original file name on reify' do
      # Check for original values
      expect(@user.name).to eq 'donald'
      expect(@user.avatar.file.filename).to match /image\.jpg$/

      @user.update_attributes! name:   'newname',
                               avatar: File.open(File.expand_path('spec/support/dummy_files/other_image.jpg'))

      # Make sure new values are applied
      expect(@user.name).to eq 'newname'
      expect(@user.avatar.file.filename).to match /other_image\.jpg$/

      # Reify original version and reload
      @user.versions.last.reify.save
      @user.reload

      # Check for original values (again)
      expect(@user.name).to eq 'donald' # Passes
      expect(@user.avatar.file.filename).to match /image\.jpg$/
    end

    it 'reloads the original file name for "avatar" on reload (after reify)' do
      @user.update_attributes! avatar: File.open(File.expand_path('spec/support/dummy_files/other_image.jpg'))
      @user.versions.last.reify.save
      @user.reload

      expect(@user.avatar.file.filename).to match /image\.jpg$/
    end

    it 'reloads the original file name for "keeping_files_avatar" on reload (after reify)' do
      @user.update_attributes! keeping_files_avatar: File.open(File.expand_path('spec/support/dummy_files/other_image.jpg'))
      @user.versions.last.reify.save
      @user.reload

      expect(@user.avatar.file.filename).to match /image\.jpg$/
    end
  end
end
