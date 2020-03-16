# Provides actions related to invites.
class InvitesController < ApplicationController
  skip_before_action :authenticate_request, only: :apply

  def show
    invite = @current_user.invite || Invite.generate_for!(@current_user)
    url = apply_invite_url(code: invite.code)
    render json: { message: 'Ok', invite: invite.to_h.merge({ url: url }) }
  end

  def apply
    full_url = File.join('/', Settings.app.registration_page)
    redirect_to url_for("#{full_url}?code=#{params[:code]}")
  end
end
