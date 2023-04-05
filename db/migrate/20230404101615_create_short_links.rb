class CreateShortLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :short_links do |t|
      t.text :url, null: false
      t.date :expires_on
      t.string :custom_key
      t.integer :click_count, default: 0
      t.string :uuid, index: true, unique: true

      t.timestamps
    end
  end
end
