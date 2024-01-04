module UsersHelper
  def has_any_social_account?
    @user.profile.x_username.present? || @user.profile.ig_username.present?
  end
end
