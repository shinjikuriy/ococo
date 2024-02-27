class UsersController < ApplicationController
  def show
    @user = User.find_by(username: params[:username])
    if @user.nil?
      flash[:warning] = t('errors.messages.page_not_found')
      redirect_to root_path
    else
      @pickles = @user.pickles.page(params[:page]).per(5)
      @journals = @user.journals.page params[:page]
      @journal = Journal.new if @user.id == current_user&.id
    end
  end
end
