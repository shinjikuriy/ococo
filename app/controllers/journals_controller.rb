class JournalsController < ApplicationController
  before_action :set_journal, only: :destroy

  # GET /journals
  def index
    @journals = Journal.order(created_at: :desc).page params[:page]
  end

  # POST /journals or /journals.json
  def create
    @journal = Journal.new(journal_params)

    if @journal.save
      flash.now[:success] = "Journal was successfully created."
    else
      render 'new', status: :unprocessable_entity
    end
  end

  # DELETE /journals/1 or /journals/1.json
  def destroy
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
end
