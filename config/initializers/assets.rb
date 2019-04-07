# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w( confirmed_classes.js )
Rails.application.config.assets.precompile += %w( courses.js )
Rails.application.config.assets.precompile += %w( requests.js )
Rails.application.config.assets.precompile += %w( sessions.js )
Rails.application.config.assets.precompile += %w( teaching_assistants.js )
Rails.application.config.assets.precompile += %w( time_blocks.js )
Rails.application.config.assets.precompile += %w( welcome.js )
