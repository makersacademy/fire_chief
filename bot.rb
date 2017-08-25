require 'sinatra/base'
require 'slack-ruby-client'
require 'json'

class API < Sinatra::Base
  post '/events' do
    request_data = JSON.parse(request.body.read)
    unless SLACK_CONFIG[:slack_verification_token] == request_data['token']
      halt 403, "Invalid Slack verification token received: #{request_data['token']}"
    end

    case request_data['type']
      when 'url_verification'
        request_data['challenge']

      when 'event_callback'
        team_id = request_data['team_id']
        event_data = request_data['event']

        if event_data['type'] == 'reaction_added'
          Events.reaction_added(team_id, event_data)
          status 200
        end

    end
  end
end

class Events

  def self.reaction_added(team_id, event_data)
    user_id = event_data['user']
    self.send_response(team_id, user_id, "#fireteam")
  end

  def self.send_response(team_id, user_id, channel = user_id)
      $teams[team_id]['client'].chat_postMessage(
        as_user: 'true',
        channel: channel,
        text: "AN EMOJI HAPPENED!!!!"
      )
  end

end
