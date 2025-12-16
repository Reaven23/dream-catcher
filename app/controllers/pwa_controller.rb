class PwaController < ApplicationController
  skip_before_action :authenticate_user!
  skip_forgery_protection

  def service_worker
    respond_to do |format|
      format.js { render content_type: 'application/javascript' }
    end
  end

  def manifest
    respond_to do |format|
      format.json { render content_type: 'application/manifest+json' }
    end
  end
end
