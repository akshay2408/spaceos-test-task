# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RemoveExpireLinksJob, type: :job do
  describe '#perform_later' do
    it 'remove expired short links' do
      ActiveJob::Base.queue_adapter = :test
      expect do
        RemoveExpireLinksJob.set(queue: 'low').perform_later('expire_link')
      end.to have_enqueued_job.with('expire_link').on_queue('low').at(:no_wait)
    end
  end
end
