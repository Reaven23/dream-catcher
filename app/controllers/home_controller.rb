class HomeController < ApplicationController
  skip_before_action :check_quiz_completion, only: [:index]

  def index
    if user_signed_in? && current_user.quiz_completed?
      @dream = Dream.new
    end
  end

  def mark_christmas_modal_seen
    if user_signed_in? && current_user.christmas_modal_shown_at.nil?
      current_user.update_column(:christmas_modal_shown_at, Time.current)
    end
    head :ok
  end
end
