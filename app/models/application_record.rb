# Represents a persisted object of the system.
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
