class StaticPagesController < ApplicationController
  def home
    @pickles = Pickle.order(created_at: :desc).take 10
    @journals = Journal.order(created_at: :desc).take 10
  end
end
