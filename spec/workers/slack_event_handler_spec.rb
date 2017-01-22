describe SlackEventHandler do
  context 'invalid request' do
    it 'exits' do
      expect(SlackWebApiClient).not_to receive(:new)
      SlackEventHandler.new.perform(message_event(token: 'wrong'))
    end
  end
  context 'valid request' do
    context 'user exists' do
      before do
        @user = create(:user)
        @company = create(:company, slack_id: 'CO1')
        @employment = create(
          :employment, company: @company, user: @user,
          slack_dm_channel_id: 'C1', slack_id: 'U1'
        )
      end
      it 'pings the user with received message' do
        expect_any_instance_of(SlackWebApiClient).to receive(:send_message)
          .with(@employment, "Received: Hello").and_call_original
        SlackEventHandler.new.perform(message_event)
      end
      context 'bot message' do
        it 'aborts' do
          expect(SlackWebApiClient).not_to receive(:new)
          params = message_event
          params['event']['subtype'] = 'bot_message'
          SlackEventHandler.new.perform(params)
        end
      end
    end
  end

  private

  def message_event(opts={})
    {
      "token": opts[:token] || "test_token",
      "team_id": "CO1",
      "api_app_id": "A1",
      "event": {
        "type": "message",
        "channel": "C1",
        "user": "U1",
        "text": "Hello",
        "ts": "1355517523.000005"
      },
      "event_ts": "1465244570.336841",
      "type": "event_callback",
      "authed_users": [
        "U061F7AUR"
      ]
    }.deep_stringify_keys
  end
end
