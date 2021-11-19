package WebService::Mattermost::V4::API;

# ABSTRACT: Mattermost API v4 wrapper.

use Moo;
use MooX::HandlesVia;
use Types::Standard qw(ArrayRef Bool InstanceOf Str);

use WebService::Mattermost::V4::API::Resource::Analytics;
use WebService::Mattermost::V4::API::Resource::Audits;
use WebService::Mattermost::V4::API::Resource::Bots;
use WebService::Mattermost::V4::API::Resource::Brand;
use WebService::Mattermost::V4::API::Resource::Cache;
use WebService::Mattermost::V4::API::Resource::Channel;
use WebService::Mattermost::V4::API::Resource::Channel::Member;
use WebService::Mattermost::V4::API::Resource::Channels;
use WebService::Mattermost::V4::API::Resource::Cluster;
use WebService::Mattermost::V4::API::Resource::Compliance;
use WebService::Mattermost::V4::API::Resource::Compliance::Report;
use WebService::Mattermost::V4::API::Resource::DataRetention;
use WebService::Mattermost::V4::API::Resource::Database;
use WebService::Mattermost::V4::API::Resource::ElasticSearch;
use WebService::Mattermost::V4::API::Resource::Email;
use WebService::Mattermost::V4::API::Resource::Emoji;
use WebService::Mattermost::V4::API::Resource::File;
use WebService::Mattermost::V4::API::Resource::Files;
use WebService::Mattermost::V4::API::Resource::Job;
use WebService::Mattermost::V4::API::Resource::Jobs;
use WebService::Mattermost::V4::API::Resource::LDAP;
use WebService::Mattermost::V4::API::Resource::Logs;
use WebService::Mattermost::V4::API::Resource::OAuth;
use WebService::Mattermost::V4::API::Resource::OAuth::Application;
use WebService::Mattermost::V4::API::Resource::Plugin;
use WebService::Mattermost::V4::API::Resource::Plugins;
use WebService::Mattermost::V4::API::Resource::Post;
use WebService::Mattermost::V4::API::Resource::Posts;
use WebService::Mattermost::V4::API::Resource::Reactions;
use WebService::Mattermost::V4::API::Resource::Roles;
use WebService::Mattermost::V4::API::Resource::S3;
use WebService::Mattermost::V4::API::Resource::SAML;
use WebService::Mattermost::V4::API::Resource::Schemes;
use WebService::Mattermost::V4::API::Resource::System;
use WebService::Mattermost::V4::API::Resource::Team;
use WebService::Mattermost::V4::API::Resource::Teams;
use WebService::Mattermost::V4::API::Resource::User;
use WebService::Mattermost::V4::API::Resource::Users;
use WebService::Mattermost::V4::API::Resource::Webhook;
use WebService::Mattermost::V4::API::Resource::WebRTC;
use WebService::Mattermost::Helper::Alias 'v4';

################################################################################

has auth_token => (is => 'ro', isa => Str, required => 1);
has base_url   => (is => 'ro', isa => Str, required => 1);

has authenticate           => (is => 'ro', isa => Bool,     default => 0);
has debug                  => (is => 'ro', isa => Bool,     default => 0);
has resources              => (is => 'rw', isa => ArrayRef, default => sub { [] },
    handles_via => 'Array',
    handles     => {
        add_resource => 'push',
    });

has analytics         => (is => 'lazy', isa => InstanceOf[v4 'Analytics']);
has application       => (is => 'lazy', isa => InstanceOf[v4 'OAuth::Application']);
has audits            => (is => 'lazy', isa => InstanceOf[v4 'Audits']);
has bots              => (is => 'lazy', isa => InstanceOf[v4 'Bots']);
has brand             => (is => 'lazy', isa => InstanceOf[v4 'Brand']);
has cache             => (is => 'lazy', isa => InstanceOf[v4 'Cache']);
has channel           => (is => 'lazy', isa => InstanceOf[v4 'Channel']);
has channel_member    => (is => 'lazy', isa => InstanceOf[v4 'Channel::Member']);
has channels          => (is => 'lazy', isa => InstanceOf[v4 'Channels']);
has cluster           => (is => 'lazy', isa => InstanceOf[v4 'Cluster']);
has compliance        => (is => 'lazy', isa => InstanceOf[v4 'Compliance']);
has compliance_report => (is => 'lazy', isa => InstanceOf[v4 'Compliance::Report']);
has data_retention    => (is => 'lazy', isa => InstanceOf[v4 'DataRetention']);
has database          => (is => 'lazy', isa => InstanceOf[v4 'Database']);
has elasticsearch     => (is => 'lazy', isa => InstanceOf[v4 'ElasticSearch']);
has email             => (is => 'lazy', isa => InstanceOf[v4 'Email']);
has emoji             => (is => 'lazy', isa => InstanceOf[v4 'Emoji']);
has file              => (is => 'lazy', isa => InstanceOf[v4 'File']);
has files             => (is => 'lazy', isa => InstanceOf[v4 'Files']);
has job               => (is => 'lazy', isa => InstanceOf[v4 'Job']);
has jobs              => (is => 'lazy', isa => InstanceOf[v4 'Jobs']);
has ldap              => (is => 'lazy', isa => InstanceOf[v4 'LDAP']);
has logs              => (is => 'lazy', isa => InstanceOf[v4 'Logs']);
has oauth             => (is => 'lazy', isa => InstanceOf[v4 'OAuth']);
has plugin            => (is => 'lazy', isa => InstanceOf[v4 'Plugin']);
has plugins           => (is => 'lazy', isa => InstanceOf[v4 'Plugins']);
has post              => (is => 'lazy', isa => InstanceOf[v4 'Post']);
has posts             => (is => 'lazy', isa => InstanceOf[v4 'Posts']);
has reactions         => (is => 'lazy', isa => InstanceOf[v4 'Reactions']);
has roles             => (is => 'lazy', isa => InstanceOf[v4 'Roles']);
has s3                => (is => 'lazy', isa => InstanceOf[v4 'S3']);
has saml              => (is => 'lazy', isa => InstanceOf[v4 'SAML']);
has schemes           => (is => 'lazy', isa => InstanceOf[v4 'Schemes']);
has system            => (is => 'lazy', isa => InstanceOf[v4 'System']);
has team              => (is => 'lazy', isa => InstanceOf[v4 'Team']);
has team_channels     => (is => 'lazy', isa => InstanceOf[v4 'Team::Channels']);
has teams             => (is => 'lazy', isa => InstanceOf[v4 'Teams']);
has user              => (is => 'lazy', isa => InstanceOf[v4 'User']);
has users             => (is => 'lazy', isa => InstanceOf[v4 'Users']);
has webhooks          => (is => 'lazy', isa => InstanceOf[v4 'Webhook']);
has webrtc            => (is => 'lazy', isa => InstanceOf[v4 'WebRTC']);

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
        api        => $self,
        auth_token => $self->auth_token,
        base_url   => $self->base_url,
        resource   => $alt_name,
        debug      => $self->debug,
    });

    $self->add_resource($resource);

    return $resource;
}

################################################################################

# The optional second parameter in some of these builders sets the "resource
# name", i.e. DataRetention's base resource is "data_retention", not
# "dataretention".

sub _build_analytics         { shift->_new_resource('Analytics')                        }
sub _build_application       { shift->_new_resource('OAuth::Application', 'oauth')      }
sub _build_audits            { shift->_new_resource('Audits')                           }
sub _build_bots              { shift->_new_resource('Bots')                             }
sub _build_brand             { shift->_new_resource('Brand')                            }
sub _build_cache             { shift->_new_resource('Cache', 'caches')                  }
sub _build_channel           { shift->_new_resource('Channel', 'channels')              }
sub _build_channel_member    { shift->_new_resource('Channel::Member', 'channels')      }
sub _build_channels          { shift->_new_resource('Channels')                         }
sub _build_cluster           { shift->_new_resource('Cluster')                          }
sub _build_compliance        { shift->_new_resource('Compliance')                       }
sub _build_compliance_report { shift->_new_resource('Compliance::Report', 'compliance') }
sub _build_config            { shift->_new_resource('Config')                           }
sub _build_data_retention    { shift->_new_resource('DataRetention', 'data_retention')  }
sub _build_database          { shift->_new_resource('Database')                         }
sub _build_elasticsearch     { shift->_new_resource('ElasticSearch')                    }
sub _build_email             { shift->_new_resource('Email')                            }
sub _build_emoji             { shift->_new_resource('Emoji')                            }
sub _build_files             { shift->_new_resource('Files')                            }
sub _build_file              { shift->_new_resource('File', 'files')                    }
sub _build_job               { shift->_new_resource('Job', 'jobs')                      }
sub _build_jobs              { shift->_new_resource('Jobs')                             }
sub _build_ldap              { shift->_new_resource('LDAP')                             }
sub _build_logs              { shift->_new_resource('Logs')                             }
sub _build_oauth             { shift->_new_resource('OAuth')                            }
sub _build_plugin            { shift->_new_resource('Plugin', 'plugins')                }
sub _build_plugins           { shift->_new_resource('Plugins')                          }
sub _build_post              { shift->_new_resource('Post', 'posts')                    }
sub _build_posts             { shift->_new_resource('Posts')                            }
sub _build_reactions         { shift->_new_resource('Reactions')                        }
sub _build_roles             { shift->_new_resource('Roles')                            }
sub _build_s3                { shift->_new_resource('S3', 'file')                       }
sub _build_saml              { shift->_new_resource('SAML')                             }
sub _build_schemes           { shift->_new_resource('Schemes')                          }
sub _build_system            { shift->_new_resource('System')                           }
sub _build_team              { shift->_new_resource('Team', 'teams')                    }
sub _build_teams             { shift->_new_resource('Teams')                            }
sub _build_team_channels     { shift->_new_resource('Team::Channels', 'team')  }
sub _build_user              { shift->_new_resource('User', 'users')                    }
sub _build_users             { shift->_new_resource('Users')                            }
sub _build_webhooks          { shift->_new_resource('Webhook', 'hooks')                 }
sub _build_webrtc            { shift->_new_resource('WebRTC')                           }

################################################################################

1;
__END__

=head1 DESCRIPTION

Container for API resources.

=head2 ATTRIBUTES

=over 4

=item * C<analytics>

See L<WebService::Mattermost::V4::API::Resource::Analytics>

=item * C<application>

See L<WebService::Mattermost::V4::API::Resource::OAuth::Application>

=item * C<audits>

See L<WebService::Mattermost::V4::API::Resource::Audits>

=item * C<brand>

See L<WebService::Mattermost::V4::API::Resource::Brand>.

=item * C<bots>

See L<WebService::Mattermost::V4::API::Resource::Bots>.

=item * C<channels>

See L<WebService::Mattermost::V4::API::Resource::Channels>.

=item * C<channel>

See L<WebService::Mattermost::V4::API::Resource::Channel>.

=item * C<channel_member>

See L<WebService::Mattermost::V4::API::Resource::Channel::Member>.

=item * C<cluster>

See L<WebService::Mattermost::V4::API::Resource::Cluster>.

=item * C<config>

See L<WebService::Mattermost::V4::API::Resource::Config>.

=item * C<compliance>

See L<WebService::Mattermost::V4::API::Resource::Compliance>.

=item * C<compliance_report>

See L<WebService::Mattermost::V4::API::Resource::Compliance::Report>.

=item * C<data_retention>

See L<WebService::Mattermost::V4::API::Resource::DataRetention>.

=item * C<database>

See L<WebService::Mattermost::V4::API::Resource::Database>.

=item * C<elasticsearch>

See L<WebService::Mattermost::V4::API::Resource::ElasticSearch>.

=item * C<email>

See L<WebService::Mattermost::V4::API::Resource::Email>.

=item * C<emoji>

See L<WebService::Mattermost::V4::API::Resource::Emoji>.

=item * C<file>

See L<WebService::Mattermost::V4::API::Resource::File>.

=item * C<files>

See L<WebService::Mattermost::V4::API::Resource::Files>.

=item * C<job>

See L<WebService::Mattermost::V4::API::Resource::Job>.

=item * C<jobs>

See L<WebService::Mattermost::V4::API::Resource::Jobs>.

=item * C<ldap>

See L<WebService::Mattermost::V4::API::Resource::LDAP>.

=item * C<logs>

See L<WebService::Mattermost::V4::API::Resource::Logs>.

=item * C<oauth>

See L<WebService::Mattermost::V4::API::Resource::OAuth>.

=item * C<plugin>

See L<WebService::Mattermost::V4::API::Resource::Plugin>.

=item * C<plugins>

See L<WebService::Mattermost::V4::API::Resource::Plugins>.

=item * C<post>

See L<WebService::Mattermost::V4::API::Resource::Post>.

=item * C<posts>

See L<WebService::Mattermost::V4::API::Resource::Posts>.

=item * C<reactions>

See L<WebService::Mattermost::V4::API::Resource::Reactions>.

=item * C<roles>

See L<WebService::Mattermost::V4::API::Resource::Roles>.

=item * C<s3>

See L<WebService::Mattermost::V4::API::Resource::S3>.

=item * C<saml>

See L<WebService::Mattermost::V4::API::Resource::SAML>.

=item * C<schemes>

See L<WebService::Mattermost::V4::API::Resource::Schemes>.

=item * C<system>

See L<WebService::Mattermost::V4::API::Resource::System>.

=item * C<team>

See L<WebService::Mattermost::V4::API::Resource::Team>.

=item * C<teams>

See L<WebService::Mattermost::V4::API::Resource::Teams>.

=item * C<user>

See L<WebService::Mattermost::V4::API::Resource::User>.

=item * C<users>

See L<WebService::Mattermost::V4::API::Resource::Users>.

=item * C<webhooks>

See L<WebService::Mattermost::V4::API::Resource::Webhook>.

=item * C<webrtc>

See L<WebService::Mattermost::V4::API::Resource::WebRTC>.

=back
