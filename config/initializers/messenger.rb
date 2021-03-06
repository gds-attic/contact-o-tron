require 'messenger'

if Rails.env.test? or ENV['NO_MESSENGER']
  Messenger.transport = Marples::NullTransport.instance
  ActiveRecord::Base.marples_transport = Marples::NullTransport.instance
else
  host = Rails.env.production? ? 'support.cluster' : 'localhost'
  uri = URI::Generic.build scheme: 'stomp', host: host, port: 61613
  failover_uri = "failover://(#{Array.new(2, uri).join(',')})" # failover://() must have multiple URIs

  if defined?(PhusionPassenger)
    PhusionPassenger.on_event(:starting_worker_process) do |forked|
      if forked
        Messenger.transport = Stomp::Client.new failover_uri
        ActiveRecord::Base.marples_transport = Stomp::Client.new failover_uri
      end
    end
  else
    Messenger.transport = Stomp::Client.new failover_uri
    ActiveRecord::Base.marples_transport = Stomp::Client.new failover_uri
  end
end
