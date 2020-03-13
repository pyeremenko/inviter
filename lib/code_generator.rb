require 'base62'

class CodeGenerator
  attr_reader :length

  def initialize(length)
    raise ArgumentError, 'Expected length to be less than 100' if length >= 100
    raise ArgumentError, 'Expected length to be greater than 0' if length <= 0

    @length = length
  end

  def generate
    rand(62**(length - 1)..(62**length - 1)).base62_encode
  end
end
