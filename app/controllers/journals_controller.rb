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
      set_params_by_referer
      set_journals_by_referer

      @journals = @journals.page
      flash.now[:success] = t('journals.shared.created_journal')
    else
      render 'new', locals: { pickles: current_user.pickles }, status: :unprocessable_entity
    end
  end

  # DELETE /journals/1 or /journals/1.json
  def destroy
    check_authorization

    set_params_by_referer
    set_journals_by_referer
    params[:page] = calc_new_pagination_number(@journals)

    @journal.destroy!
    @journals = @journals.page params[:page]
    flash.now[:success] = t('journals.shared.destroyed_journal')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_journal
      @journal = Journal.find_by(id: params[:id])
      if @journal.nil?
        flash[:warning] = t('errors.messages.page_not_found')
        redirect_to root_url
      end
    end

    # Only allow a list of trusted parameters through.
    def journal_params
      params.require(:journal).permit(:pickle_id, :body)
    end

    def check_authorization
      redirect_to root_url unless @journal.user.id == current_user.id
    end

    def set_params_by_referer
      params.delete(:id)
      params.delete(:journal)

      referer = Rails.application.routes.recognize_path(request.referer)
      params[:controller] = referer[:controller]
      params[:action] = referer[:action]

      params[:username] = current_user if params[:controller] == 'users' && params[:action] == 'show'
      params[:id] = @journal.pickle if params[:controller] == 'pickles' && params[:action] == 'show'
    end

    def set_journals_by_referer
      referer = Rails.application.routes.recognize_path(request.referer)
      if referer[:controller] == 'users' && referer[:action] == 'show'
        @journals = current_user.journals
      elsif referer[:controller] == 'pickles' && referer[:action] == 'show'
        @journals = @journal.pickle.journals
      elsif (referer[:controller] == 'journals' && referer[:action] == 'index') ||
            (referer[:controller] == 'static_pages' && referer[:action] == 'home')
        @journals = Journal.order(created_at: :desc)
      end
    end

    def calc_new_pagination_number(journals)
      journals.each_slice(Journal.default_per_page).with_index(1) do |j, i|
        next unless j.include? @journal
        # returns the previous page number if the current page disappears by deletion
        return j.length == 1 ? i-1 : i
      end
    end
end
