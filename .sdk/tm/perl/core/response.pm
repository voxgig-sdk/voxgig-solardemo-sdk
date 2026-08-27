# Solardemo SDK response

use strict;
use warnings;

use File::Basename ();
use Cwd ();
use Scalar::Util ();

my $__dir;
BEGIN { $__dir = File::Basename::dirname(Cwd::abs_path(__FILE__)) }
require(Cwd::abs_path("$__dir/../lib/Voxgig/Struct.pm"));
require(Cwd::abs_path("$__dir/helpers.pm"));

package SolardemoResponse;

sub new {
  my ($class, $resmap) = @_;
  $resmap = {} unless defined $resmap;

  my $s = SolardemoHelpers::gp($resmap, 'status');
  my $status = (defined $s && !ref $s && Scalar::Util::looks_like_number($s)) ? int($s) : -1;

  my $st = SolardemoHelpers::gp($resmap, 'statusText');
  my $status_text = (defined $st && !ref $st) ? "$st" : '';

  my $jf = SolardemoHelpers::gp($resmap, 'json');
  my $json_func = (ref $jf eq 'CODE') ? $jf : undef;

  return bless {
    status      => $status,
    status_text => $status_text,
    headers     => SolardemoHelpers::gp($resmap, 'headers'),
    json_func   => $json_func,
    body        => SolardemoHelpers::gp($resmap, 'body'),
    err         => SolardemoHelpers::gp($resmap, 'err'),
  }, $class;
}

1;
