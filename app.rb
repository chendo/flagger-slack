require 'bundler'

Bundler.require

post '/event' do
  payload = JSON.parse(request.body.string)

  namespace = payload.dig('namespace')
  name = payload.dig('name')
  phase = payload.dig('phase')

  msg = payload.dig('metadata', 'eventMessage')

  str = "#{namespace}/#{name}: [#{phase}] #{msg}"
  data = {
    text: str
  }
  resp = Excon.post(ENV.fetch('SLACK_WEBHOOK_URL'), headers: {'Content-Type': 'application/json'}, body: JSON.dump(data))

  'ok'
end