class SocialProvider < ActiveRecord::Base
  belongs_to :user
  LIST = {
    facebook: 'facebook',
    linkedin: 'linkedin'
  }

  validates :uid, presence: true, uniqueness: {scope: :provider}
  validates :provider, presence: true
  
end
