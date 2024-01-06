class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def edit
    @profile = Profile.find_by(user_id: params[:user_id])
  end

  def update
    @profile = Profile.find_by(user_id: params[:user_id])

    if @profile.update(profile_params)
      flash[:success] = t('.profile_successfully_updated')
      redirect_to show_user_url(params[:user_id])
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:display_name, :prefecture, :description, :x_username, :ig_username, :avatar)
  end
end
