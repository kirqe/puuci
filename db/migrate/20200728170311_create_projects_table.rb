class CreateProjectsTable < ActiveRecord::Migration[6.0]
  def change
    # enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    create_table :projects, id: :uuid, default: 'gen_random_uuid()', force: true do |t|
      t.string :name
      t.text :note
      t.integer :priority, default: 1
      t.uuid :user_id
      
      t.boolean :active, default: true
      t.boolean :draft, default: true

      t.timestamps
    end
  end
end
