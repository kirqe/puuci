class CreateIssuesTable < ActiveRecord::Migration[6.0]
  def change
    create_table :issues, id: :uuid, default: 'gen_random_uuid()', force: true do |t|
      t.string :name
      t.string :note
      t.integer :priority, default: 1
      t.uuid :project_id
      t.uuid :user_id

      t.boolean :draft, default: true

      t.timestamps
    end
  end
end
