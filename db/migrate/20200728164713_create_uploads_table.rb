# frozen_string_literal: true

class CreateUploadsTable < ActiveRecord::Migration[6.0]
  def change
    # enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    create_table :uploads, id: :uuid, default: 'gen_random_uuid()', force: true do |t|
      t.string :filename
      t.string :ext
      t.uuid :uploadable_id, default: 'gen_random_uuid()'
      t.string :uploadable_type

      t.timestamps
    end
    add_index :uploads, %i[uploadable_type uploadable_id]
  end
end
