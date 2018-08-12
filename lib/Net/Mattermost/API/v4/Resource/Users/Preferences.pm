package Net::Mattermost::API::v4::Resource::Users::Preferences;

use Moo;

extends 'Net::Mattermost::API::v4::Resource';

################################################################################

sub get_preferences_by_id {
    my $self = shift;
    my $id   = shift;

    return $self->_call({
        method   => $self->get,
        endpoint => '%s/preferences',
        ids      => [ $id ],
    });
}

sub get_specific_preference_by_id {
    my $self       = shift;
    my $user_id    = shift;
    my $category   = shift;
    my $preference = shift;

    return $self->_call({
        method   => $self->get,
        endpoint => '%s/preferences/%s/name/%s',
        ids      => [ $user_id, $category, $preference ],
    });
}

sub list_preferences_by_category {
    my $self     = shift;
    my $user_id  = shift;
    my $category = shift;

    return $self->_call({
        method   => $self->get,
        endpoint => '%s/preferences/%s',
        ids      => [ $user_id, $category ],
    });
}

sub delete_preferences_by_id {
    my $self = shift;
    my $id   = shift;

    return $self->_call({
        method   => $self->delete,
        endpoint => '%s/preferences/delete',
        ids      => [ $id ],
    });
}

sub save_preferences_by_id {
    my $self = shift;
    my $id   = shift;
    my $args = shift;

    return $self->_call({
        method     => $self->put,
        endpoint   => '%s/preferences',
        ids        => [ $id ],
        parameters => $args,
    });
}

################################################################################

1;

