# frozen_string_literal: true

# This job to remove all the expired short links.
class RemoveExpireLinksJob < ApplicationJob
  def perform
    ShortLink.where(expires_at: Date.today).delete_all
  end
end
