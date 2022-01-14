module PragmaticQL
  class IncludeModel
    attr_reader :hooks

    def initialize(include_hash)
      @include_hash = include_hash
      @hooks = []
    end

    def for(node_name)
      hooks.each { |hook| hook.for(node_name) }

      node_hash = @include_hash.fetch(node_name.to_sym) { {} }
      new_im = IncludeModel.new(node_hash)
      hooks.each { |hook| new_im.hooks << hook }
      new_im
    end

    def inclusive_of?(key_name)
      hooks.each { |hook| hook.inclusive_of?(key_name) }

      level_keys.include?(key_name.to_sym)
    end

    def pagination
      @pagination ||= Pagination.new(self)
    end

    def inclusive_of_any?
      level_keys.any?
    end

    def empty?
      level_keys.empty?
    end

    def inspect
      "<#IncludeModel #{@include_hash.inspect}>"
    end

    def or(other)
      hooks.each { |hook| hook.or(other) }
      self.empty? ? other : self
    end

    def level_keys
      @include_hash.keys
    end
  end
end
