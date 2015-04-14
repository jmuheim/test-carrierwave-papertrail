class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :avatar
      t.string :keeping_files_avatar

      t.timestamps null: false
    end
  end
end
