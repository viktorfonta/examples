require 'rails_helper'

describe BaseService do
  let(:service) { BaseService.new }
  let!(:city) { FactoryGirl.create(:city) }
  let!(:university) { FactoryGirl.create(:university) }

  describe '#find_or_create_city' do
    context 'find' do
      before { service.find_or_create_city(city.name) }

      it { expect(City.count).to eq 1 }
    end

    context 'create' do
      before { service.find_or_create_city('My City') }

      it { expect(City.count).to eq 2 }
    end
  end

  describe '#find_or_create_university' do
    context 'find' do
      before { service.find_or_create_university(university.name) }

      it { expect(University.count).to eq 1 }
    end

    context 'create' do
      before { service.find_or_create_university('My University') }

      it { expect(University.count).to eq 2 }
    end
  end
end
