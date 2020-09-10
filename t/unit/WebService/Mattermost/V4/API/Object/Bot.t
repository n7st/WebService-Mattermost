#!/usr/bin/env perl -T

use Test::Spec;

use WebService::Mattermost::V4::API::Object::Bot;
use WebService::Mattermost::TestHelper qw(
    AUTH_TOKEN
    BASE_URL

    expects_api_call
);

describe 'WebService::Mattermost::V4::API::Object::Bot' => sub {
    describe '.new' => sub {
        it 'should build a bot object from a raw data hash' => sub {
            my $bot = WebService::Mattermost::V4::API::Object::Bot->new({
                auth_token => AUTH_TOKEN,
                base_url   => BASE_URL,
                raw_data   => {
                    create_at    => 1599757323,
                    delete_at    => 1599757323,
                    description  => 'my bot',
                    display_name => 'bot',
                    owner_id     => 'my-owner-id',
                    update_at    => 1599757323,
                    user_id      => 'my-user-id',
                    username     => 'botuser',
                },
            });

            my $now = DateTime->from_epoch(epoch => 1599757);

            is 'my bot',     $bot->description,  'Description set correctly';
            is 'bot',        $bot->display_name, 'Display name set correctly';
            is 'my-user-id', $bot->user_id,      'Bot user ID set correctly';
            is 'botuser',    $bot->username,     'Bot username set correctly';

            foreach my $date (qw(created_at deleted_at updated_at)) {
                is $now, $bot->$date, "${date} set correctly";
            }
        };

        it 'should link its creator' => sub {
            my $owner_id = 'my-owner-id';
            my $bot      = WebService::Mattermost::V4::API::Object::Bot->new({
                auth_token => AUTH_TOKEN,
                base_url   => BASE_URL,
                raw_data   => { owner_id => $owner_id },
            });

            is $owner_id, $bot->creator_id, 'creator_id set correctly';

            expects_api_call($bot, {
                method   => 'get',
                resource => 'user',
                url      => "/users/${owner_id}",
            });

            ok $bot->created_by;
        };
    };
};

runtests unless caller;
