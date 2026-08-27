# Solardemo SDK error

use strict;
use warnings;

package SolardemoError;

use overload
  '""'     => sub { defined $_[0]->{msg} ? $_[0]->{msg} : '' },
  'bool'   => sub { 1 },
  fallback => 1;

sub new {
  my ($class, $code, $msg, $ctx) = @_;
  return bless {
    is_sdk_error => 1,
    sdk          => 'Solardemo',
    code         => (defined $code ? $code : ''),
    msg          => (defined $msg ? $msg : ''),
    ctx          => $ctx,
    result       => undef,
    spec         => undef,
  }, $class;
}

sub code  { $_[0]->{code} }
sub msg   { $_[0]->{msg} }
sub error { $_[0]->{msg} }

1;
