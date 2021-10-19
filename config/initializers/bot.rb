ENV['ACCESS_TOKEN'] = Rails.application.credentials.dig(:fb_bot, :access_token)
ENV['APP_SECRET'] = Rails.application.credentials.dig(:fb_bot, :app_secret)
ENV['VERIFY_TOKEN'] = Rails.application.credentials.dig(:fb_bot, :verify_token)

unless Rails.env.production?
  bot_files = Dir[Rails.root.join('app', 'bot', '**', '*.rb')]
  bot_reloader = ActiveSupport::FileUpdateChecker.new(bot_files) do
    bot_files.each{ |file| require_dependency file }
  end

  ActiveSupport::Reloader.to_prepare do
    bot_reloader.execute_if_updated
  end

  bot_files.each { |file| require_dependency file }
end
