module Decidim
  class ParticipatoryProcessPresenter
    prepend Module.new {
      def hero_image_url
        if model.banner_image.attached?
          url_for(model.banner_image)
        else
          asset_path("decidim/default_banner.jpg")
        end
      end
    }
  end
end