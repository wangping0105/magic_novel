# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)
require 'faye'

use Faye::RackAdapter, :mount => '/faye', :timeout => 25 do |bayeux|
  bayeux.add_extension(ServerAuth.new)
end
run Rails.application
