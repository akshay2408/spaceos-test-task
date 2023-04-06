# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShortLink, type: :model do
  describe 'validations' do
    let(:short_link) { build(:short_link) }

    context 'with valid attributes' do
      it 'is valid' do
        expect(short_link).to be_valid
      end
    end

    context 'without a url' do
      before { short_link.url = nil }

      it 'is not valid' do
        expect(short_link).to_not be_valid
      end
    end

    context 'with a non-unique uuid' do
      let!(:existing_short_link) { create(:short_link) }
      before { short_link.uuid = existing_short_link.uuid }

      it 'is not valid' do
        expect(short_link).to_not be_valid
      end
    end

    context 'with a non-unique custom key' do
      let!(:existing_short_link) { create(:short_link, custom_key: 'abc') }
      before { short_link.custom_key = existing_short_link.custom_key }

      it 'is not valid' do
        expect(short_link).to_not be_valid
      end
    end
  end

  describe 'before_validation' do
    let(:short_link) { build(:short_link) }

    context 'when generating a uuid and setting expires_on' do
      before { short_link.valid? }

      it 'generates a uuid' do
        expect(short_link.uuid).to_not be_nil
      end

      it 'sets expires_on' do
        expect(short_link.expires_on).to_not be_nil
      end
    end

    context 'when setting expires_on based on expires_in_days' do
      let(:short_link) { create(:short_link, expires_in_days: 10) }

      it 'sets expires_on correctly' do
        expect(short_link.expires_on).to eq(10.days.from_now.to_date)
      end
    end

    context 'when not setting expires_in_days' do
      let(:short_link) { create(:short_link) }

      it 'sets expires_on to DEFAULT_EXPIRY_DAYS' do
        expect(short_link.expires_on).to eq(30.days.from_now.to_date)
      end
    end
  end

  describe '.find_by_uuid_or_custom_key' do
    let!(:short_link1) { create(:short_link) }
    let!(:short_link2) { create(:short_link, custom_key: 'abc') }

    context 'when finding by uuid' do
      it 'finds the short link' do
        expect(ShortLink.find_by_uuid_or_custom_key(short_link1.uuid)).to eq(short_link1)
      end
    end

    context 'when finding by custom_key' do
      it 'finds the short link' do
        expect(ShortLink.find_by_uuid_or_custom_key('abc')).to eq(short_link2)
      end
    end

    context 'when no record is found' do
      it 'raises ActiveRecord::RecordNotFound' do
        expect { ShortLink.find_by_uuid_or_custom_key('invalid_id') }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
