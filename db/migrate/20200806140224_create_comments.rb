class CreateComments < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    create_table :comments, id: :uuid, default: 'gen_random_uuid()', force: true do |t|
      t.uuid :user_id
      t.text :message
      t.uuid :commentable_id, default: 'gen_random_uuid()'
      t.string  :commentable_type
      
      t.timestamps
    end
    add_index :comments, [:commentable_type, :commentable_id]
  end
end
