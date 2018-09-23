package WebService::Mattermost::V4::API::Object::Plugin;

use Moo;
use Types::Standard qw(Bool HashRef Maybe Str);

extends 'WebService::Mattermost::V4::API::Object';
with    qw(
    WebService::Mattermost::V4::API::Object::Role::Description
    WebService::Mattermost::V4::API::Object::Role::Name
    WebService::Mattermost::V4::API::Object::Role::ID
);

################################################################################

has backend         => (is => 'ro', isa => Maybe[HashRef]);
has prepackaged     => (is => 'ro', isa => Maybe[Bool]);
has settings_schema => (is => 'ro', isa => Maybe[HashRef]);
has version         => (is => 'ro', isa => Maybe[Str]);
has webapp          => (is => 'ro', isa => Maybe[HashRef]);

################################################################################

around BUILDARGS => sub {
    my $orig = shift;
    my $self = shift;
    my $args = shift;

    # Convert JSON::PP::Boolean into regular boolean
    $args->{prepackaged} = $args->{prepackaged} ? 1 : 0;

    return $self->$orig($args);
};

################################################################################

1;
__END__

=head1 NAME

WebService::Mattermost::V4::API::Object::Plugin

=head1 DESCRIPTION

An active or inactive plugin.

=head2 ATTRIBUTES

=over 4

=item C<backend>

=item C<prepackaged>

=item C<settings_schema>

=item C<version>

=item C<webapp>

=back

=head1 SEE ALSO

=over 4

=item C<WebService::Mattermost::V4::API::Object::Role::Description>

=item C<WebService::Mattermost::V4::API::Object::Role::Name>

=item C<WebService::Mattermost::V4::API::Object::Role::ID>

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

