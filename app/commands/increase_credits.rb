# This command performs the main rule of the system:
# When a user signs up using a valid invite, their credits should be increased by 10.
# When 5 users registered by the same code, the owner of this code should get 10 credits.
class IncreaseCredits
  prepend SimpleCommand
  @@increase_usages_semaphore = Mutex.new # rubocop:disable Style/ClassVars

  APPLY_BONUS_AFTER = 5

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
