class HomeController < ApplicationController
  skip_before_action :check_quiz_completion, only: [:index]

  def index
    if user_signed_in? && current_user.quiz_completed?
      @dream = Dream.new
    end
  end
end
