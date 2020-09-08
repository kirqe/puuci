class CreateUsersTable < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    create_table :users, id: :uuid, default: 'gen_random_uuid()', force: true do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.string :auth_token
      t.string :about
      t.integer :role, default: 4 # regular user

      t.timestamps
    end
  end
end