class LastSearch < ActiveRecord::Base
  belongs_to :user, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  validates :user_id, :receiver_id, presence: true

  scope :newest, -> {order('last_searches.updated_at desc')}
  scope :only_user, -> {select('users.*')}
end
