module PragmaticQL
  class Pagination
    attr_reader :current_level_im

    def initialize(current_level_im)
      @current_level_im = current_level_im
    end

    def page
      page = current_level_im.for(:page).level_keys.first.to_s.to_i
      return 1 if page < 1
      page
    end

    def limit
      lim = current_level_im.for(:limit).level_keys.first.to_s.to_i

      if lim > 0 && lim < PragmaticQL.config.pagination_max_limit
        lim
      else
        PragmaticQL.config.pagination_max_limit
      end
    end

    def order
      value = current_level_im.for(:order).level_keys.first
      return :desc if value == :desc
      :asc
    end
  end
end
