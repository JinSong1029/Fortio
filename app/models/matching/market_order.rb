require_relative 'constants'

module Matching
  class MarketOrder
    attr :id, :timestamp, :type, :volume, :sum_limit, :market

    def initialize(attrs)
      @id          = attrs[:id]
      @timestamp   = attrs[:timestamp]
      @type        = attrs[:type].try(:to_sym)
      @sum_limit   = attrs[:sum_limit].try(:to_d)
      @volume      = attrs[:volume].try(:to_d)
      @market      = Market.find attrs[:market]

      raise ::Matching::InvalidOrderError.new(attrs) unless valid?(attrs)
    end

    def fill(v)
      raise NotEnoughVolume if v > @volume
      @volume -= v
    end

    def crossed?(price)
      true
    end

    def label
      "%d/%.04f" % [id, volume]
    end

    def valid?(attrs)
      return false unless [:ask, :bid].include?(type)
      return false if attrs[:price].present? # should have no limit price
      return false if type == :bid && sum_limit <= ZERO
      id && timestamp && market && volume > ZERO
    end

  end
end
