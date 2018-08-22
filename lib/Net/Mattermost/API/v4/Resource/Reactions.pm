package Net::Mattermost::API::v4::Resource::Reactions;

use Moo;

extends 'Net::Mattermost::API::v4::Resource';

################################################################################

sub react {
    my $self       = shift;
    my $post_id    = shift;
    my $emoji_name = shift;
    my $user_id    = shift;

    return $self->_post({
        parameters => {
            post_id    => $post_id,
            emoji_name => $emoji_name,
            user_id    => $user_id,
        },
    });
}

################################################################################

1;

