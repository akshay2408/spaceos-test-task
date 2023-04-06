# frozen_string_literal: true

module JsonResponseHelper
  def json_response
    @json_response ||= prepare_json_response(JSON.parse(response.body))
  end

  private

  def prepare_json_response(data)
    case data
    when Array
      data.map { |d| prepare_json_response(d) }
    when Hash
      data.with_indifferent_access
    else
      data
    end
  end
end
