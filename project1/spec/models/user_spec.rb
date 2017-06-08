require 'rails_helper'

RSpec.describe User, type: :model do
  context 'student' do
    subject { build(:student) }

    it { is_expected.to be_valid }
  end
end
