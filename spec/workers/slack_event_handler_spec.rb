describe SlackEventHandler do
  context 'invalid request' do
    it 'exits' do
      expect(SlackMessageHandler).not_to receive(:new)
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
      it 'sends the event to the event handler' do
        expect(SlackMessageHandler).to receive(:new).with(
          company: @company, employment: @employment,
          message: "Hello"
        ).and_call_original
        expect_any_instance_of(SlackMessageHandler).to receive(:process!)
        SlackEventHandler.new.perform(message_event)
      end
      context 'change message' do
        it 'sends the change event to the event handler' do
          expect(SlackMessageHandler).to receive(:new).with(
            company: @company, employment: @employment,
            message: "~Hello~"
          ).and_call_original
          expect_any_instance_of(SlackMessageHandler).to receive(:process!)
          SlackEventHandler.new.perform(message_change_event)
        end
      end
      context 'bot message' do
        it 'aborts' do
          expect(SlackMessageHandler).not_to receive(:new)
          params = message_event
          params['event']['subtype'] = 'bot_message'
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

  def message_change_event(opts={})
    {
      "api_app_id": "A3S",
      "authed_users": [
        "U1"
      ],
      "event": {
        "channel": "C1",
        "event_ts": "1485325280.215539",
        "hidden": true,
        "message": {
          "edited": {
            "ts": "1485425280.000000",
            "user": "U1"
          },
          "text": "~Hello~",
          "ts": "1485425227.000002",
          "type": "message",
          "user": "U1"
        },
        "previous_message": {
          "text": "Hello",
          "ts": "1485425227.000002",
          "type": "message",
          "user": "U1"
        },
        "subtype": "message_changed",
        "ts": "1485425280.000004",
        "type": "message"
      },
      "team_id": "CO1",
      "token": opts[:token] || "test_token",
      "type": "event_callback"
    }.deep_stringify_keys
  end
end
