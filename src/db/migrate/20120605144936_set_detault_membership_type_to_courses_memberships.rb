class SetDetaultMembershipTypeToCoursesMemberships < ActiveRecord::Migration
  def change
    change_column :course_memberships, :membership_type, :string, :default => "student"
  end
end
