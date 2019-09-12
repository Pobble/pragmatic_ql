module PragmaticQL
  class IncludeModel
    def initialize(include_hash)
      @include_hash = include_hash
    end

    def for(node_name)
      node_hash = @include_hash.fetch(node_name.to_sym) { {} }
      IncludeModel.new(node_hash)
    end

    def inclusive_of?(key_name)
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
      self.empty? ? other : self
    end

    def level_keys
      @include_hash.keys
    end
  end
end
