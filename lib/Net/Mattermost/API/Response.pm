package Net::Mattermost::API::Response;

use Mojo::JSON 'decode_json';
use Moo;
use Types::Standard qw(Any Bool HashRef InstanceOf Int Str);

################################################################################

has code        => (is => 'ro', isa => Int,                                   required => 1);
has headers     => (is => 'ro', isa => InstanceOf['Mojo::Headers'],           required => 1);
has message     => (is => 'ro', isa => Str,                                   required => 0);
has prev        => (is => 'ro', isa => InstanceOf['Mojo::Message::Response'], required => 1);
has raw_content => (is => 'ro', isa => Str,                                   required => 0);

has is_error   => (is => 'ro', isa => Bool, default => 0);
has is_success => (is => 'ro', isa => Bool, default => 1);

has content => (is => 'rw', isa => Any, default => sub { {} });

################################################################################

sub BUILD {
    my $self = shift;

    if ($self->raw_content && $self->raw_content =~ /^[\{\[]/) {
        $self->content(decode_json($self->raw_content));
    }

    return 1;
}

################################################################################

1;
__END__

=head1 NAME

Net::Mattermost::API::Response - container for responses from the Mattermost API

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

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

