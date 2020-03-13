# Represents an invitation record.
#
class Invite < ApplicationRecord
  GENERATE_RETRIES = 20
  CODE_LENGTH = 5
  @@increase_usages_semaphore = Mutex.new # rubocop:disable Style/ClassVars

  validates :code, presence: true

  belongs_to :user

  def self.generate!(user)
    generator = CodeGenerator.new(CODE_LENGTH)
    GENERATE_RETRIES.times do
      code = generator.generate
      begin
        return Invite.create!(user: user, code: code)
      rescue ActiveRecord::RecordNotUnique
        next
      rescue StandardError
        raise # raise if it's not a RecordNotUnique error
      end
    end
    # raise the last error if we unable to provide a code in a reasonable number of attempts
    raise("Failed to generate a code in #{GENERATE_RETRIES} atempts")
  end

  def to_h
    { code: code, used: (usages || 0) }
  end

  def increase_usages!
    @@increase_usages_semaphore.synchronize do
      increment!(:usages)
    end
  end
end
