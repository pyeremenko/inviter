# Provides actions related to invites.
class InvitesController < ApplicationController
  def show
    invite = @current_user.invite || Invite.generate_for!(@current_user)
    render json: { message: 'Ok.', invite: invite.to_h }
  end
end
