# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets for Sneat template
Rails.application.config.assets.precompile += %w(
  core.css
  theme-default.css
  demo.css
  vendor/perfect-scrollbar.css
  pages/page-auth.css
  pages/page-account-settings.css
  pages/page-icons.css
  pages/page-misc.css
)
