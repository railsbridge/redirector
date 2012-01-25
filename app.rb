require "sinatra"

get "*" do
  'This app is just a redirector. You probably want <a href="http://railsbridge.org">railsbridge.org</a>.'
end
