module ActiveSupport
  # Provides accurate date and time measurements using Date#advance and 
  # Time#advance, respectively. It mainly supports the methods on Numeric,
  # such as in this example:
  #
  #   1.month.ago       # equivalent to Time.now.advance(:months => -1)
  class Duration < Builder::BlankSlate
    attr_accessor :value, :parts
    
    def initialize(value, parts) #:nodoc:
      @value, @parts = value, parts
    end
    
    # Adds another Duration or a Numeric to this Duration. Numeric values
    # are treated as seconds.
    def +(other)
      if Duration === other
        Duration.new(value + other.value, @parts + other.parts)
      else
        Duration.new(value + other, @parts + [[:seconds, other]])
      end
    end
    
    # Subtracts another Duration or a Numeric from this Duration. Numeric
    # values are treated as seconds.
    def -(other)
      self + (-other)
    end
    
    def -@ #:nodoc:
      Duration.new(-value, parts.map { |type,number| [type, -number] })
    end
    
    def is_a?(klass) #:nodoc:
      klass == Duration || super
    end
    
    def self.===(other) #:nodoc:
      other.is_a?(Duration) rescue super
    end
    
    # Calculates a new Time or Date that is as far in the future
    # as this Duration represents.
    def since(time = ::Time.now)
      sum(1, time)
    end
    alias :from_now :since
    
    # Calculates a new Time or Date that is as far in the past
    # as this Duration represents.
    def ago(time = ::Time.now)
      sum(-1, time)
    end
    alias :until :ago
    
    def inspect #:nodoc:
      consolidated = parts.inject(Hash.new(0)) { |h,part| h[part.first] += part.last; h }
      [:years, :months, :days, :hours, :minutes, :seconds].map do |length|
        n = consolidated[length]
        "#{n} #{n == 1 ? length.to_s.singularize : length.to_s}" if n.nonzero?
      end.compact.to_sentence
    end
    
    protected
    
    def sum(sign, time = ::Time.now) #:nodoc:
      parts.inject(time) do |t,(type,number)|
        if t.acts_like?(:time)
          if type == :seconds
            t + (sign * number)
          else
            t.advance(type => sign * number)
          end
        elsif t.acts_like?(:date)
          raise ArgumentError, "Adding seconds to a Date does not make sense" if type == :seconds
          t.advance(type => sign * number)
        else
          raise ArgumentError, "expected a time or date, got #{time.inspect}"
        end
      end
    end
    
    private
    
    def method_missing(method, *args, &block) #:nodoc:
      value.send(method, *args)
    end
  end
end