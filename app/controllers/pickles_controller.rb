class PicklesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @pickles = Pickle.all.order(created_at: :desc).page params[:page]
  end

  def show
    @pickle = Pickle.find(params[:id])
  end

  def new
    @pickle = Pickle.new
    build_nested_attributes
  end

  def create
    @pickle = Pickle.build(pickle_params)
    if @pickle.save
      flash[:success] = t('pickles.new.created_pickle')
      redirect_to pickle_path(@pickle)
    else
      build_nested_attributes
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    @pickle = Pickle.find(params[:id])
    build_nested_attributes
  end

  def update
    @pickle = Pickle.find(params[:id])
    if @pickle.update(pickle_params)
      flash[:success] = t('pickles.edit.edited_pickle')
      redirect_to pickle_path(@pickle)
    else
      build_nested_attributes
      render 'edit', status: :unprocessable_entity
    end
  end

  private

  def pickle_params
    params.require(:pickle).permit(:name, :preparation, :process, :note,
                                   ingredients_attributes: [:id, :name, :quantity, :_destroy],
                                   sauce_materials_attributes: [:id, :name, :quantity, :_destroy]
                                   ).merge(user_id: current_user.id)
  end

  def build_nested_attributes
    @pickle.ingredients.build if @pickle.ingredients.empty?
    @pickle.sauce_materials.build if @pickle.sauce_materials.empty?
  end
end
