class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper Rails.application.routes.url_helpers

  before_action :require_sign_in

  private

  def current_person
    ::Person.find_by(id: params[:signed_in_as])
  end

  def after_settings_change(section:, person:)
    response.headers["X-Settings-Change"] = "#{section.key}:#{person.id}"
  end

  def can?(capability)
    params[:capabilities].to_s.split(",").include?(capability.to_s)
  end

  def require_sign_in
    redirect_to "/sign_in" if params[:signed_in] == "no"
  end
end
