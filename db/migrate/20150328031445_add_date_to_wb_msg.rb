class AddDateToWbMsg < ActiveRecord::Migration
  def change
    add_column :wb_msgs, :created_date, :datetime
  end
end
