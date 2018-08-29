package WebService::Mattermost::API::v4::Request;

use DDP;
use Mojo::URL;
use Mojo::Util 'url_escape';
use Moo;
use Types::Standard qw(Any ArrayRef Enum InstanceOf Str);

################################################################################

has base_url => (is => 'ro', isa => Str,                              required => 1);
has endpoint => (is => 'ro', isa => Str,                              required => 1);
has method   => (is => 'ro', isa => Enum [ qw(DELETE GET POST PUT) ], required => 1);
has resource => (is => 'ro', isa => Str,                              required => 1);

# Some endpoints require parameters as a HashRef, some as an ArrayRef
has parameters => (is => 'ro', isa => Any,      default => sub { {} });
has ids        => (is => 'ro', isa => ArrayRef, default => sub { [] });

has url => (is => 'ro', isa => InstanceOf['Mojo::URL'], lazy => 1, builder => 1);

################################################################################

sub _build_url {
    my $self = shift;

    my $base_url = $self->base_url;
    my $resource = $self->resource;
    my $endpoint = $self->endpoint;

    $base_url .= '/' if $base_url !~ /\/$/;
    $resource .= '/' if $self->endpoint ne '' && $resource !~ /\/$/;

    my @ids = map { url_escape($_) } @{$self->ids};

    $endpoint = sprintf($endpoint, @ids);

    my $url = sprintf('%s%s%s', $base_url, $resource, $endpoint);
    p $url;

    return Mojo::URL->new($url);
}

################################################################################

1;

