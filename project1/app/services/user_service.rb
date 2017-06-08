class UserService
  class << self
    def hide_unconfirmed_users
      User.where("confirmation_sent_at<? AND confirmed_at IS NULL AND unconfirmed_email IS NULL", Time.now.utc - User.confirm_within).find_each do |user|
        User.where(id: user.id).update_all(email: User::FAKE_EMAIL.gsub(/\{id\}/, user.id.to_s), unconfirmed_email: user.email)
      end
    end
  end
end