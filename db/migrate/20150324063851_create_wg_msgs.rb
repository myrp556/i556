class CreateWgMsgs < ActiveRecord::Migration
  def change
    create_table :wg_msgs do |t|
      t.string :author
      t.text :content
      t.references :user, index: true

      t.timestamps
    end
  end
end
