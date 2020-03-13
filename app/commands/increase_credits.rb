class IncreaseCredits
  prepend SimpleCommand

  def initialize(invite, invitee)
    @invite = invite
    @invitee = invitee
  end

  def call
    @inviter = @invite.user
    
    @@increase_usages_semaphore.synchronize do
      @invitee.increment!(:credits, 10)
      @invite.increment!(:usages, 1)

      if @invite.usages >= APPLY_BONUS_AFTER && !@invite.bonus_applied
        @inviter.increment!(:credits, 10)
        @invite.update!(bonus_applied: true)
      end
    end
  end
end