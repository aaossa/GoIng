class AddCourseRefToRequests < ActiveRecord::Migration[5.2]
  def change
    add_reference :requests, :course, foreign_key: true
  end
end
