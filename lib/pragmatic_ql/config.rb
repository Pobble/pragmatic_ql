module PragmaticQL
  class Config
    attr_writer :pagination_max_limit

    def pagination_max_limit
      @pagination_max_limit || 50
    end
  end
end
