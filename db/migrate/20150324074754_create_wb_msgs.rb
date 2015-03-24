class CreateWbMsgs < ActiveRecord::Migration
  def change
    create_table :wb_msgs do |t|
      t.string :auther
      t.string :content
      t.references :user, index: true

      t.timestamps
    end
  end
end
