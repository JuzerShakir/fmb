class PagesController < ApplicationController
  allow_unauthenticated_access
  before_action :return_to_default_path, if: -> { authenticated? }

  def home
  end
end
