# WebService::Mattermost

Suite for interacting with Mattermost chat servers. Includes API and WebSocket
gateways.

## Installation

### From CPAN

```
% cpanm WebService::Mattermost
```

### Manual

```
% git clone ssh://git@git.netsplit.uk:7170/mike/WebService-Mattermost.git
% cd WebService-Mattermost
% dzil listdeps | cpanm
% dzil authordeps | cpanm
% dzil install
```

## API usage

```perl
use WebService::Mattermost;

my $mattermost = WebService::Mattermost->new({
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

extends 'WebService::Mattermost::WS::v4';

# WebService::Mattermost::WS::v4 emits events which can be caught with these
# methods. None of them are required and they all pass two arguments ($self,
# HashRef $args).
sub gw_ws_started {}

sub gw_ws_finished {}

sub gw_message {
    my $self = shift;
    my $args = shift;

    # The message's data is in $args
}

sub gw_error {}

sub gw_message_no_event {}

1;
```

## License

MIT. See LICENSE.txt.

