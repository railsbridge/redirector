here = File.dirname(__FILE__)
require "refraction"
require "#{here}/app"

Refraction.configure do |req|
  case req.host
  when 'builders.railsbridge.org'
    req.permanent! 'http://railsbridge.org'
  when /(www.)?railsbridge.(org|com)/
    req.permanent! :host => 'railsbridge.org'
  end
end
use Refraction
run Sinatra::Application
