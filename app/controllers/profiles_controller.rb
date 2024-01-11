class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def edit
    @profile = current_user.profile
  end

  def update
    @profile = current_user.profile

    if @profile.update(profile_params)
      flash[:success] = t('.profile_successfully_updated')
      redirect_to show_user_url(@profile.user.username)
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:display_name, :prefecture, :description, :x_username, :ig_username, :avatar)
  end
end
