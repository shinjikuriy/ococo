class JournalsController < ApplicationController
  before_action :set_journal, only: %i[ show edit update destroy ]

  # GET /journals or /journals.json
  def index
    @journals = Journal.order(created_at: :desc).page params[:page]
  end

  # GET /journals/1 or /journals/1.json
  def show
  end

  # GET /journals/new
  def new
    @journal = Journal.new
  end

  # GET /journals/1/edit
  def edit
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

  # PATCH/PUT /journals/1 or /journals/1.json
  def update
    respond_to do |format|
      if @journal.update(journal_params)
        format.html { redirect_to journal_url(@journal), notice: "Journal was successfully updated." }
        format.json { render :show, status: :ok, location: @journal }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @journal.errors, status: :unprocessable_entity }
      end
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
