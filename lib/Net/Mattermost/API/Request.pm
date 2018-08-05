package Net::Mattermost::API::Request;

use DDP;
use Mojo::URL;
use Moo;
use Types::Standard qw(Enum HashRef InstanceOf Str);

################################################################################

has base_url => (is => 'ro', isa => Str,                              required => 1);
has endpoint => (is => 'ro', isa => Str,                              required => 1);
has method   => (is => 'ro', isa => Enum [ qw(DELETE GET POST PUT) ], required => 1);
has resource => (is => 'ro', isa => Str,                              required => 1);

has parameters => (is => 'ro', isa => HashRef, default => sub { {} });

has url => (is => 'ro', isa => InstanceOf['Mojo::URL'], lazy => 1, builder => 1);

################################################################################

sub _build_url {
    my $self = shift;

    my $base_url = $self->base_url;
    my $resource = $self->resource;

    $base_url .= '/' if $base_url !~ /\/$/;
    $resource .= '/' if $self->endpoint ne '' && $resource !~ /\/$/;

    my $url = sprintf('%s%s%s', $base_url, $resource, $self->endpoint);
    p $url;

    return Mojo::URL->new($url);
}

################################################################################

1;

