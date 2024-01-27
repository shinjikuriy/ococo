class UsersController < ApplicationController
  def show
    @user = User.find_by(username: params[:username])
    if @user.nil?
      flash.now[:warning] = t('errors.messages.page_not_found')
      render 'static_pages/home', status: :not_found
    else
      @pickles = @user.pickles.order(updated_at: :desc).page params[:page]
    end
  end
end
