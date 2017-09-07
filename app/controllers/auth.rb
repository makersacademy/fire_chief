class FireChief < Sinatra::Base

  get '/' do
    redirect '/begin_auth'
  end

  get '/begin_auth' do
    status 200
    erb :'partials/add_to_slack'
  end

  get '/finish_auth' do
    client = Slack::Web::Client.new
    begin
      response = client.oauth_access(
        {
          client_id: SLACK_CONFIG[:slack_client_id],
          client_secret: SLACK_CONFIG[:slack_api_secret],
          redirect_uri: SLACK_CONFIG[:slack_redirect_uri],
          code: params[:code] # (This is the OAuth code mentioned above)
        }
      )
      team_id = response['team_id']
      $teams[team_id] = {
        user_access_token: response['access_token'],
        bot_user_id: response['bot']['bot_user_id'],
        bot_access_token: response['bot']['bot_access_token']
      }

      $teams[team_id]['client'] = create_slack_client(response['bot']['bot_access_token'])
      status 200
      body "Yay! Auth succeeded! You're awesome!"
    rescue Slack::Web::Api::Error => e
      status 403
      body "Auth failed! Reason: #{e.message}<br/>#{add_to_slack_button}"
    end
  end
end
