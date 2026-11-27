# VoxgigSolardemo SDK utility: prepare_auth

use strict;
use warnings;

use File::Basename ();
use Cwd ();

my $__dir;
BEGIN { $__dir = File::Basename::dirname(Cwd::abs_path(__FILE__)) }
require(Cwd::abs_path("$__dir/../lib/Voxgig/Struct.pm"));
require(Cwd::abs_path("$__dir/../core/helpers.pm"));

package VoxgigSolardemoUtilities;

our %REGISTRY;

# This SDK is configured with authentication off, so there is no credential
# to place. The entry stays in the registry because make_spec calls it
# unconditionally, and still guards the spec so the auth_no_spec contract
# holds for every SDK.
$REGISTRY{prepare_auth} = sub {
  my ($ctx) = @_;
  my $spec = $ctx->{spec};
  return (undef, $ctx->make_error('auth_no_spec',
    'Expected context spec property to be defined.')) unless $spec;

  return ($spec, undef);
};

1;
