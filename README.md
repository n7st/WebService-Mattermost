# WebService::Mattermost ![test status](https://github.com/n7st/webservice-mattermost/workflows/test/badge.svg)

`WebService::Mattermost` is a suite for interacting with Mattermost chat servers.
It includes an API client and a WebSocket gateway.

See individual POD files for details.

## Installation

### From CPAN

```
% cpanm WebService::Mattermost
```

### Manual

```
% git clone git@github.com:n7st/WebService-Mattermost.git
% cd WebService-Mattermost
% dzil listdeps | cpanm
% dzil authordeps | cpanm
% dzil install
```

## API usage

Currently, only API version 4 (latest) is supported.

```perl
use WebService::Mattermost;

my $mattermost = WebService::Mattermost->new({
    authenticate => 1, # Log into Mattermost
    debug        => 1, # Output some debug-level information via Mojo::Log
    username     => 'email@address.com',
    password     => 'hunter2',
    base_url     => 'https://my.mattermost.server.com/api/v4/',
});

# API methods available under:
my $api = $mattermost->api;
```

## WebSocket gateway usage

### Emitted events

| Event                 | Purpose                                                              |
| :-------------------- | :------------------------------------------------------------------- |
| `gw_message_no_event` | A message with no event type was received (ping or unknown event)    |
| `gw_ws_started`       | The WebSocket client started                                         |
| `gw_ws_finished`      | The WebSocket client's connection was closed                         |
| `gw_ws_error`         | An error occurred                                                    |
| `gw_message`          | A chat message was received                                          |

### Extending with `Moo` or `Moose` 

```perl
package SomePackage;

use Moo;

extends 'WebService::Mattermost::V4::Client';

# WebService::Mattermost::V4::Client emits events which can be caught with these
# methods. None of them are required and they all pass two arguments ($self,
# HashRef $args).
sub gw_ws_started {}

sub gw_ws_finished {}

sub gw_message {
    my $self = shift;
    my $args = shift;

    # The message's data is in $args
}

sub gw_ws_error {}

sub gw_message_no_event {}

1;
```

### As a script

```perl
use WebService::Mattermost::V4::Client;

my $bot = WebService::Mattermost::V4::Client->new({
    username => 'usernamehere',
    password => 'password',
    base_url => 'https://mattermost.server.com/api/v4/',

    # Optional arguments
    debug                     => 1,   # Show extra connection information
    ignore_self               => 0,   # May cause recursion!
    reauthentication_interval => 600, # Shorten the reauthentication loop delay
});

$bot->on(gw_message => sub {
    my ($bot, $args) = @_;

    # $args contains the decoded message content
});

$bot->start(); # Add me last
```

The available events are the same. See [here](#emitted-events) for a full list.

## Running the test suite

```
% prove -lv t/**/*.t
```

## License

MIT. See LICENSE.txt.
