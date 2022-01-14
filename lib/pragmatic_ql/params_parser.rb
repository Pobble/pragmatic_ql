#?include=student_type.works,student_type.works_per_page_10,student_works_page_1,student_type.work.names

module PragmaticQL
  # Main purpouse is to convert include_string from params (`account.names,account.email_identity.email`)
  # to merged hash:
  #
  # {
  #   account: {
  #     names: {}
  #     email_identity: {
  #       email: {}
  #     }
  #   }
  # }
  #
  # ...that will then  get recognized by IncludeModel to respond to `IncludeModel#inclusive_of(:acount)
  #
  class ParamsParser
    attr_reader :include_string

    def initialize(include_string: )
      @include_string = include_string
    end

    def include_model
      @include_model ||= IncludeModel.new(include_hash)
    end

    private

    def include_hash
      return {} if include_string.blank?
      include_list = include_string
        .gsub(/\s/, '')
        .split(',')
        .map { |con| con.split('.') }

      include_hash = {}
      parse_first_level(include_hash, include_list)
      include_hash.deep_symbolize_keys
    end

    def parse_first_level(include_hash, include_list)
      include_list.each do |conditions|
        if conditions.is_a?(Array)
          name = conditions.shift
          include_hash[name] ||= {}
          include_hash[name].merge!(parse_second_level(include_hash[name], conditions))
        else
          include_hash[conditions] = {}
        end
      end
      include_hash
    end

    def parse_second_level(include_hash, item)
      if item.is_a?(Array)
        if item.any?
          name = item.shift
          include_hash[name] ||= {}
          parse_second_level(include_hash[name], item)
        else
          {}
        end
      else
        include_hash.merge!({item => item})
      end
    end
  end
end
