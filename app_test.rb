require "rack/test"
require "wrong"

class Test
  include Rack::Test::Methods
  include Wrong

  def app
    here = File.dirname(__FILE__)
    @app ||= begin
      app, options = Rack::Builder.parse_file "#{here}/config.ru"
      app
    end
  end

  def go
    get "/"
    assert { last_response.ok? }

    get "/", {}, "HTTP_HOST" => "www.railsbridge.org"
    assert("redirects permanently") { last_response.status == 301 }
    assert("redirects www.railsbridge.org to railsbridge.org") { last_response['Location'] == "http://railsbridge.org/" }

    get "/foo", {}, "HTTP_HOST" => "www.railsbridge.org"
    assert { last_response.status == 301 }
    assert("saves the path when redirecting from www.railsbridge.org") { last_response['Location'] == "http://railsbridge.org/foo" }

    get "/foo", {}, "HTTP_HOST" => "www.railsbridge.com"
    assert { last_response.status == 301 }
    assert("saves the path when redirecting from www.railsbridge.com") { last_response['Location'] == "http://railsbridge.org/foo" }

    get "/foo", {}, "HTTP_HOST" => "railsbridge.com"
    assert { last_response.status == 301 }
    assert("saves the path when redirecting from railsbridge.com") { last_response['Location'] == "http://railsbridge.org/foo" }

    get "/foo", {}, "HTTP_HOST" => "builders.railsbridge.org"
    assert { last_response.status == 301 }
    assert("doesn't save the path when redirecting from builders.railsbridge.org") { last_response['Location'] == "http://railsbridge.org" }

  end
end
Test.new.go
puts "Success!"
