class CreateAppVersions < ActiveRecord::Migration
  def change
    create_table :app_versions do |t|
      t.string :name
      t.integer :app_type
      t.string :version_name
      t.string :version_code
      t.string :download_url
      t.integer :upgrade
      t.text :changelogs

      t.timestamps
    end
  end
end
