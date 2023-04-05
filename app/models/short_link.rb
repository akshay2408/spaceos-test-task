# frozen_string_literal: true

class ShortLink < ApplicationRecord
  DEFAULT_EXPIRY_DAYS = 30

  attr_accessor :expires_in_days

  validates_presence_of :url
  validates_uniqueness_of :uuid, :custom_key

  before_validation do
    self.uuid = SecureRandom.hex(3)
    self.expires_on = Time.current + expiry_days
  end

  def self.find_by_uuid_or_custom_key(unique_id)
    find_by!('uuid = ? OR custom_key = ?', unique_id, unique_id)
  end

  def short_url_identifer
    custom_key.present? ? custom_key : uuid
  end

  def increment_click_count!
    update(click_count: click_count + 1)
  end

  private

  def expiry_days
    (expires_in_days ? expires_in_days.to_i : DEFAULT_EXPIRY_DAYS).days
  end
end
