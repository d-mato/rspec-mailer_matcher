# frozen_string_literal: true

require 'open3'
require 'rbconfig'

RSpec.describe 'loading the gem' do
  it 'does not require rspec to be loaded first' do
    output, status = Open3.capture2e(
      RbConfig.ruby, '-e', 'require "rspec-mailer_matcher"'
    )
    expect(status).to be_success, output
  end
end
