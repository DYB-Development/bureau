class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :require_sign_in

  private

  def current_person
    ::Person.find_by(id: params[:person_id])
  end

  def require_sign_in
    redirect_to "/sign_in" if params[:signed_in] == "no"
  end
end
