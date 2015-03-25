class AddAutherToWbmsg < ActiveRecord::Migration
  def change
    add_column :wb_msgs, :auther_id, :integer
  end
end
