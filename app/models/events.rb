class Events

  def self.reaction_added(team_id, event_data)
    user_id = event_data['user']
    self.send_response(team_id, user_id, "#fireteam")
  end

  def self.send_response(team_id, user_id, channel = user_id)
      $teams[team_id]['client'].chat_postMessage(
        as_user: 'true',
        channel: channel,
        text: "I'M A BOT, YOU IDIOT!!!!"
      )
  end
end
