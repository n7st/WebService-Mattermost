# Net::Mattermost

Suite for interacting with Mattermost chat servers. Includes API and WebSocket
gateways.

## API usage

```perl

use Net::Mattermost;

my $mattermost = Net::Mattermost->new({
    authenticate => 1, # Log into Mattermost
    username     => 'email@address.com',
    password     => 'hunter2',
    base_url     => 'https://my.mattermost.server.com/api/v4/',
});

# API methods available under:
my $api = $mattermost->api->v4;

```

## WebSocket gateway usage

```perl
package SomePackage;

use Moo;

extends 'Net::Mattermost::WS::v4';

# Methods from Net::Mattermost::WS::v4 which may be overridden
sub on_connect {

}

sub on_message {

}

sub on_quit {

}

sub on_default_event {

}

1;
```

## License

MIT. See LICENSE.txt.

