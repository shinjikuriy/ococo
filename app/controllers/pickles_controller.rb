class PicklesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_pickle, only: [:show, :edit, :update, :destroy]

  def index
    @pickles = Pickle.all.order(created_at: :desc).page params[:page]
  end

  def show
    @journals = @pickle.journals.page params[:page]
    @journal = Journal.new(pickle_id: @pickle.id) if @pickle.user.id == current_user&.id
  end

  def new
    @pickle = Pickle.new(started_on: Time.zone.today)
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
    check_authorization
    build_nested_attributes
  end

  def update
    if @pickle.update(pickle_params)
      flash[:success] = t('pickles.edit.edited_pickle')
      redirect_to pickle_path(@pickle)
    else
      build_nested_attributes
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    check_authorization
    if @pickle.destroy
      flash[:success] = t('pickles.shared.destroyed_pickle')
      redirect_to user_url(current_user), status: :see_other
    else
      flash[:danger] = t('pickles.shared.failed_to_destroy_pickle')
      render 'edit'
    end
  end

  private

  def set_pickle
    @pickle = Pickle.find_by(id: params[:id])
    if @pickle.nil?
      flash[:warning] = t('errors.messages.page_not_found')
      redirect_to root_url
    end
  end

  def pickle_params
    params.require(:pickle).permit(:name, :preparation, :process, :note, :started_on,
                                   ingredients_attributes: [:id, :name, :quantity, :_destroy],
                                   sauce_materials_attributes: [:id, :name, :quantity, :_destroy]
                                   ).merge(user_id: current_user.id)
  end

  def build_nested_attributes
    @pickle.ingredients.build if @pickle.ingredients.empty?
    @pickle.sauce_materials.build if @pickle.sauce_materials.empty?
  end

  def check_authorization
    redirect_to pickle_url(@pickle) unless @pickle.user.id == current_user.id
  end
end
