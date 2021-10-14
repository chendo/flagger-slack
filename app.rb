require 'bundler'

Bundler.require

post "/event/#{ENV['SECRET']}" do
  request.body.rewind
  payload = JSON.parse(request.body.read)

  namespace = payload.dig('namespace')
  name = payload.dig('name')
  phase = payload.dig('phase')

  msg = payload.dig('metadata', 'eventMessage')

  str = "#{namespace}/#{name}: [#{phase}] #{msg}"
  data = {
    channel: '#ci',
    text: str
  }
  resp = Excon.post(
    ENV.fetch('SLACK_WEBHOOK_URL'),
    headers: {
      'Content-Type': 'application/json',
      'User-Agent': 'flagger-slack',
      'Host' => 'hooks.slack.com',
    },
    body: JSON.dump(data),
    expects: [200]
  )

  'ok'
end