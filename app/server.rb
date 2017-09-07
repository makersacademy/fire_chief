class FireChief < Sinatra::Base
  set :partial_template_engine, :erb
  
  SLACK_CONFIG = {
    slack_client_id: ENV['SLACK_CLIENT_ID'],
    slack_api_secret: ENV['SLACK_API_SECRET'],
    slack_redirect_uri: ENV['SLACK_REDIRECT_URI'],
    slack_verification_token: ENV['SLACK_VERIFICATION_TOKEN']
  }

  missing_params = SLACK_CONFIG.select { |key, value| value.nil? }
  if missing_params.any?
    error_msg = missing_params.keys.join(", ").upcase
    raise "Missing Slack config variables: #{error_msg}"
  end

  BOT_SCOPE = 'bot'
  $teams = {}

  def create_slack_client(slack_api_secret)
    Slack.configure do |config|
      config.token = slack_api_secret
      fail 'Missing API token' unless config.token
    end
    Slack::Web::Client.new
  end
end
