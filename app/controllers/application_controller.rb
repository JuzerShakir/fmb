class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  include Pagy::Backend
  add_flash_types :success, :notice

  rescue_from CanCan::AccessDenied do
    return_to_default_path(type: :alert, msg: "flash.un_authorize")
  end
end
