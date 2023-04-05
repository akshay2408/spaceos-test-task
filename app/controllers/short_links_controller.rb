# frozen_string_literal: true

class ShortLinksController < ApplicationController
  before_action :set_short_url, only: :show

  def create
    short_link = ShortLink.find_or_initialize_by(url: short_link_params[:url]).tap do |link|
      link.custom_key = short_link_params[:custom_key]
      link.expires_in_days = short_link_params[:expires_in_days]

      link.save!
    end

    json_response({
                    message: 'success',
                    data: { short_url: short_link_url(short_link.short_url_identifer), expires_on: short_link.expires_on }
                  }, :created)
  end

  def show
    @short_url.increment_click_count!

    json_response({
                    message: 'success',
                    data: { redirect_to: @short_url.url, metrices: { click_count: @short_url.click_count } }
                  })
  end

  private

  def set_short_url
    @short_url = ShortLink.find_by_uuid_or_custom_key(params[:id])
  end

  def short_link_params
    params.require(:short_link).permit(:url, :expires_in_days, :custom_key)
  end
end
