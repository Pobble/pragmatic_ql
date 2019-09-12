require 'spec_helper'
RSpec.describe PragmaticQL::Config do
  it do
    expect(PragmaticQL.config.pagination_max_limit).to eq 50

    PragmaticQL.config.pagination_max_limit = 100
    expect(PragmaticQL.config.pagination_max_limit).to eq 100

    PragmaticQL.config.pagination_max_limit = 50  # reset back to orginal value
  end
end
