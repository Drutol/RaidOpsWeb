class AddNTimeToAttendance < ActiveRecord::Migration
  def change
    add_column :attendances, :n_time, :integer
  end
end
