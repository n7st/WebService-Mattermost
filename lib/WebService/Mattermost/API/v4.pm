package WebService::Mattermost::API::v4;

use Moo;
use MooX::HandlesVia;
use Types::Standard qw(ArrayRef Bool InstanceOf Str);

use WebService::Mattermost::API::v4::Resource::Brand;
use WebService::Mattermost::API::v4::Resource::Channels;
use WebService::Mattermost::API::v4::Resource::Cluster;
use WebService::Mattermost::API::v4::Resource::Compliance;
use WebService::Mattermost::API::v4::Resource::DataRetention;
use WebService::Mattermost::API::v4::Resource::ElasticSearch;
use WebService::Mattermost::API::v4::Resource::Emoji;
use WebService::Mattermost::API::v4::Resource::Files;
use WebService::Mattermost::API::v4::Resource::Jobs;
use WebService::Mattermost::API::v4::Resource::LDAP;
use WebService::Mattermost::API::v4::Resource::OAuth;
use WebService::Mattermost::API::v4::Resource::Plugins;
use WebService::Mattermost::API::v4::Resource::Posts;
use WebService::Mattermost::API::v4::Resource::Reactions;
use WebService::Mattermost::API::v4::Resource::Roles;
use WebService::Mattermost::API::v4::Resource::SAML;
use WebService::Mattermost::API::v4::Resource::Schemes;
use WebService::Mattermost::API::v4::Resource::System;
use WebService::Mattermost::API::v4::Resource::Teams;
use WebService::Mattermost::API::v4::Resource::Users;
use WebService::Mattermost::API::v4::Resource::Webhooks;
use WebService::Mattermost::Helper::Alias 'v4';

################################################################################

has base_url => (is => 'ro', isa => Str, required => 1);

has authenticate => (is => 'ro', isa => Bool,     default => 0);
has resources    => (is => 'rw', isa => ArrayRef, default => sub { [] },
    handles_via => 'Array',
    handles     => {
        add_resource => 'push',
    });

has brand          => (is => 'ro', isa => InstanceOf[v4 'Brand'],         lazy => 1, builder => 1);
has channels       => (is => 'ro', isa => InstanceOf[v4 'Channels'],      lazy => 1, builder => 1);
has cluster        => (is => 'ro', isa => InstanceOf[v4 'Cluster'],       lazy => 1, builder => 1);
has compliance     => (is => 'ro', isa => InstanceOf[v4 'Compliance'],    lazy => 1, builder => 1);
has data_retention => (is => 'ro', isa => InstanceOf[v4 'DataRetention'], lazy => 1, builder => 1);
has elasticsearch  => (is => 'ro', isa => InstanceOf[v4 'ElasticSearch'], lazy => 1, builder => 1);
has emoji          => (is => 'ro', isa => InstanceOf[v4 'Emoji'],         lazy => 1, builder => 1);
has files          => (is => 'ro', isa => InstanceOf[v4 'Files'],         lazy => 1, builder => 1);
has jobs           => (is => 'ro', isa => InstanceOf[v4 'Jobs'],          lazy => 1, builder => 1);
has ldap           => (is => 'ro', isa => InstanceOf[v4 'LDAP'],          lazy => 1, builder => 1);
has oauth          => (is => 'ro', isa => InstanceOf[v4 'OAuth'],         lazy => 1, builder => 1);
has plugins        => (is => 'ro', isa => InstanceOf[v4 'Plugins'],       lazy => 1, builder => 1);
has posts          => (is => 'ro', isa => InstanceOf[v4 'Posts'],         lazy => 1, builder => 1);
has reactions      => (is => 'ro', isa => InstanceOf[v4 'Reactions'],     lazy => 1, builder => 1);
has roles          => (is => 'ro', isa => InstanceOf[v4 'Roles'],         lazy => 1, builder => 1);
has saml           => (is => 'ro', isa => InstanceOf[v4 'SAML'],          lazy => 1, builder => 1);
has schemes        => (is => 'ro', isa => InstanceOf[v4 'Schemes'],       lazy => 1, builder => 1);
has system         => (is => 'ro', isa => InstanceOf[v4 'System'],        lazy => 1, builder => 1);
has teams          => (is => 'ro', isa => InstanceOf[v4 'Teams'],         lazy => 1, builder => 1);
has users          => (is => 'ro', isa => InstanceOf[v4 'Users'],         lazy => 1, builder => 1);
has webhooks       => (is => 'ro', isa => InstanceOf[v4 'Webhooks'],      lazy => 1, builder => 1);

################################################################################

sub BUILD {
    my $self = shift;

    foreach my $name (sort $self->meta->get_attribute_list) {
        my $attr = $self->meta->get_attribute($name);

        if ($attr->has_builder) {
            my $cref = $self->can($name);

            $self->$cref;
        }
    }

    return 1;
}

################################################################################

sub _new_resource {
    my $self     = shift;
    my $name     = shift;
    my $alt_name = shift || lc $name;

    my $resource = v4($name)->new({
        resource => $alt_name,
        base_url => $self->base_url,
    });

    $self->add_resource($resource);

    return $resource;
}

################################################################################

sub _build_brand          { shift->_new_resource('Brand')                           }
sub _build_channels       { shift->_new_resource('Channels')                        }
sub _build_cluster        { shift->_new_resource('Cluster')                         }
sub _build_compliance     { shift->_new_resource('Compliance')                      }
sub _build_data_retention { shift->_new_resource('DataRetention', 'data_retention') }
sub _build_elasticsearch  { shift->_new_resource('ElasticSearch')                   }
sub _build_emoji          { shift->_new_resource('Emoji')                           }
sub _build_files          { shift->_new_resource('Files')                           }
sub _build_jobs           { shift->_new_resource('Jobs')                            }
sub _build_ldap           { shift->_new_resource('LDAP')                            }
sub _build_oauth          { shift->_new_resource('OAuth')                           }
sub _build_plugins        { shift->_new_resource('Plugins')                         }
sub _build_posts          { shift->_new_resource('Posts')                           }
sub _build_reactions      { shift->_new_resource('Reactions')                       }
sub _build_roles          { shift->_new_resource('Roles')                           }
sub _build_saml           { shift->_new_resource('SAML')                            }
sub _build_schemes        { shift->_new_resource('Schemes')                         }
sub _build_system         { shift->_new_resource('System')                          }
sub _build_teams          { shift->_new_resource('Teams')                           }
sub _build_users          { shift->_new_resource('Users')                           }
sub _build_webhooks       { shift->_new_resource('Webhooks')                        }

################################################################################

1;

