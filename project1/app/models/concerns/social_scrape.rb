require 'net/http'

module SocialScrape
  extend ActiveSupport::Concern
  include UrlHelpers

  included do
    after_save :fb_scrape

    private
    def facebook_scrape_entity(entity)
      delay.facebook_scrape_page(url_helpers.url_for(controller: 'sharings',
                                                     action: :scrape,
                                                     id: entity.id,
                                                     protocol: (Rails.env.staging? || Rails.env.production?) ? :https : :http)
      )
    end

    def facebook_scrape_page(url)
      uri = URI('https://graph.facebook.com')
      request = Net::HTTP::Post.new(uri)
      request.set_form_data(scrape: 'true', id: url)
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(request)
      end
    end
  end
end