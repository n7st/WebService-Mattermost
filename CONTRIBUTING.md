# Contributing to WebService::Mattermost

## Reporting bugs

The primary issue tracker is [here](https://github.com/n7st/WebService-Mattermost/issues).

Before opening an issue, please check if there are already any matching your
problem [here](https://github.com/n7st/WebService-Mattermost/issues). If you
find a closed issue, please open a new one and provide a link to the closed one.

Please provide the following information where possible:

* A clear and descriptive title.
* Reproduction steps for the bug, such as a code snippet which demonstrates the
  issue.
* What you expect the library should be doing.
* Your Perl version (found by running `perl -v`).
* Your operating system.

## Making code changes

First, please check for issues marked as
[help wanted](https://github.com/n7st/WebService-Mattermost/labels/help-wanted).

### Local development

In order to make contributions to the API or websocket clients you will need
access to a [Mattermost](https://mattermost.com/) server to test against.

The best way to bootstrap a local development environment is by using
[`Dist::Zilla`](http://dzil.org). See the [README](./README.md#Manual) for
information on installing the library's dependencies.

### Testing

The library's test suite is found in the
[`t` directory](https://github.com/n7st/WebService-Mattermost/tree/master/t).
It uses [`Test::Spec`](https://metacpan.org/pod/Test::Spec) for BDD/rspec style
tests.

Ideally, new features or bugfixes should be confirmed with matching tests.

### Opening a pull request

Please fill out the sections in the pull request template.

## Suggesting enhancements

Enhancements should be suggested using the
[issue tracker](https://github.com/n7st/WebService-Mattermost/issues) or can be
discussed in IRC [here](ircs://irc.snoonet.org:+6697/##Mike).

Before making a suggestion, please check there isn't an open issue or pull
request which matches what you would like.

