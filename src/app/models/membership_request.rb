# == Schema Information
#
# Table name: membership_requests
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  course_id       :integer
#  membership_type :string(255)
#  read            :boolean          default(FALSE)
#  confirmed       :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class MembershipRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  attr_accessible :user_id, :course_id, :membership_type
end
