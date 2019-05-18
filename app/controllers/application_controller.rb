# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_gon_variables

  def self.render_with_signed_in_user(user, *args)
    ActionController::Renderer::RACK_KEY_TRANSLATION['warden'] ||= 'warden'
    proxy = Warden::Proxy.new({}, Warden::Manager.new({})).tap { |i| i.set_user(user, scope: :user) }
    renderer = self.renderer.new('warden' => proxy)
    renderer.render(*args)
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to  do |format|
      format.js { head :forbidden }
      format.json { head :forbidden }
      format.html { redirect_to root_url, alert: exception.message }
    end
  end

  check_authorization unless: :devise_controller?

  private

  def set_gon_variables
    gon.current_user_id = current_user&.id
  end
end
