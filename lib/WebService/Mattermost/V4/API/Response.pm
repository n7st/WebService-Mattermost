package WebService::Mattermost::V4::API::Response;

use Mojo::JSON 'decode_json';
use Moo;
use Types::Standard qw(Any ArrayRef Bool InstanceOf Int Maybe Object Str);

use WebService::Mattermost::V4::API::Object::Channel;
use WebService::Mattermost::V4::API::Object::Compliance::Report;
use WebService::Mattermost::V4::API::Object::Emoji;
use WebService::Mattermost::V4::API::Object::Error;
use WebService::Mattermost::V4::API::Object::User;
use WebService::Mattermost::Helper::Alias 'view';

extends 'WebService::Mattermost';

################################################################################

has code        => (is => 'ro', isa => Int,                                   required => 1);
has headers     => (is => 'ro', isa => InstanceOf['Mojo::Headers'],           required => 1);
has message     => (is => 'ro', isa => Str,                                   required => 0);
has prev        => (is => 'ro', isa => InstanceOf['Mojo::Message::Response'], required => 1);
has raw_content => (is => 'ro', isa => Str,                                   required => 0);
has item_view   => (is => 'ro', isa => Maybe[Str],                            required => 0);
has single_item => (is => 'ro', isa => Bool,                                  required => 0);

has is_error   => (is => 'ro', isa => Bool, default => 0);
has is_success => (is => 'ro', isa => Bool, default => 1);

has content => (is => 'rw', isa => Any, default => sub { {} });

has item  => (is => 'ro', isa => Maybe[Object],   lazy => 1, builder => 1);
has items => (is => 'ro', isa => Maybe[ArrayRef], lazy => 1, builder => 1);

################################################################################

sub BUILD {
    my $self = shift;

    # Rudimentary "is it JSON?" hack
    if ($self->raw_content && $self->raw_content =~ /^[\{\[]/) {
        $self->content(decode_json($self->raw_content));
    }

    return 1;
}

################################################################################

sub _build_item {
    my $self = shift;

    my $item;

    if (scalar @{$self->items}) {
        $item = $self->items->[0];
    }

    return $item;
}

sub _build_items {
    my $self = shift;

    my @ret;

    if ($self->item_view) {
        my @items = ref $self->content eq 'ARRAY' ? @{$self->content} : ($self->content);

        if ($items[0]->{status_code} && $items[0]->{status_code} != 200) {
            # The response is actually an error - create an Error view
            push @ret, view('Error')->new({
                raw_data    => $items[0],
                api_version => $self->api_version,
            });
        } else {
            @ret = map {
                view($self->item_view)->new({
                    raw_data    => $_,
                    api_version => $self->api_version,
                })
            } @items;
        }
    }

    return \@ret;
}

################################################################################

1;
__END__

=head1 NAME

WebService::Mattermost::API::Response - container for responses from the Mattermost API

=head1 DESCRIPTION

A common container for responses from the Mattermost API.

=head2 ATTRIBUTES

=over 4

=item C<code>

The HTTP code returned.

=item C<headers>

Headers from the C<Mojo::Message::Response> object.

=item C<message>

A message (or undef) from the API (for example if there is a C<code> of 403,
the C<message> will be "Forbidden").

=item C<prev>

The returned C<Mojo::Message::Response> object.

=item C<raw_content>

JSON-encoded content or undef.

=item C<is_error>

=item C<is_success>

=item C<content>

Decoded content in ArrayRef or HashRef form.

=item C<item_view>

Whether or not the response should try to create a v4::Object object.

=item C<single_item>

Whether or not the expected v4::Object should be an ArrayRef.

=item C<item>

The first v4::Object object.

=item C<items>

All view objects.

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

