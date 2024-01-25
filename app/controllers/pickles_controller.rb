class PicklesController < ApplicationController
  before_action :authenticate_user!

  def new
    @pickle = Pickle.new
    @pickle.ingredients.build
    @pickle.sauce_materials.build
  end

  def create
    @pickle = Pickle.build(pickle_params)
    if @pickle.save
      flash[:success] = t('pickles.new.created_pickle')
      redirect_to pickle_path(@pickle)
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def show
    @pickle = Pickle.find(params[:id])
  end

  private

  def pickle_params
    params.require(:pickle).permit(:name, :preparation, :process, :note,
                                   ingredients_attributes: [:name, :quantity],
                                   sauce_materials_attributes: [:name, :quantity]
                                   ).merge(user_id: current_user.id)
  end
end
