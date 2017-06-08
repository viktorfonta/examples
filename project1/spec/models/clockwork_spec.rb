require 'rails_helper'
require 'open3'

RSpec.describe Clockwork do

  describe 'clock script' do
    it 'is valid' do
      stdin, stdout, stderr = Open3.popen3('bundle exec ruby ./lib/clock.rb')
      expect(stderr.readlines).to be_empty
    end
  end
end
