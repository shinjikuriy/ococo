class JournalsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_journal, only: :destroy

  # GET /journals
  def index
    @journals = Journal.order(created_at: :desc).page params[:page]
  end

  # POST /journals or /journals.json
  def create
    @journal = Journal.new(journal_params)
    check_authorization

    if @journal.save
      flash.now[:success] = t('journals.shared.created_journal')
    else
      render 'new', locals: { pickles: current_user.pickles }, status: :unprocessable_entity
    end
  end

  # DELETE /journals/1 or /journals/1.json
  def destroy
    check_authorization
    @journal.destroy!
    flash.now[:success] = t('journals.shared.destroyed_journal')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_journal
      @journal = Journal.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def journal_params
      params.require(:journal).permit(:pickle_id, :body)
    end

    def check_authorization
      redirect_to root_url unless @journal.user.id == current_user.id
    end
end
