require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_mailer/railtie'
require 'action_controller/railtie'
require "action_cable/engine"
# require 'action_text/engine'
# require 'action_view/railtie'
# require 'action_mailbox/engine'
# require 'active_storage/engine'
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Inviter
  class Application < Rails::Application
    config.load_defaults 6.0
    config.api_only = true
    config.autoload_paths << Rails.root.join('lib')
  end
end
