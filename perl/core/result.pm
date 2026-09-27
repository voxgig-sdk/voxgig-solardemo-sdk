# VoxgigSolardemo SDK result

use strict;
use warnings;

use File::Basename ();
use Cwd ();
use Scalar::Util ();

my $__dir;
BEGIN { $__dir = File::Basename::dirname(Cwd::abs_path(__FILE__)) }
require(Cwd::abs_path("$__dir/../lib/Voxgig/Struct.pm"));
require(Cwd::abs_path("$__dir/helpers.pm"));

package VoxgigSolardemoResult;

sub new {
  my ($class, $resmap) = @_;
  $resmap = {} unless defined $resmap;

  my $s = VoxgigSolardemoHelpers::gp($resmap, 'status');
  my $status = (defined $s && !ref $s && Scalar::Util::looks_like_number($s)) ? int($s) : -1;

  my $st = VoxgigSolardemoHelpers::gp($resmap, 'statusText');
  my $status_text = (defined $st && !ref $st) ? "$st" : '';

  my $h = VoxgigSolardemoHelpers::gp($resmap, 'headers');
  my $rm = VoxgigSolardemoHelpers::gp($resmap, 'resmatch');

  return bless {
    ok          => VoxgigSolardemoHelpers::is_true(VoxgigSolardemoHelpers::gp($resmap, 'ok')) ? 1 : 0,
    status      => $status,
    status_text => $status_text,
    headers     => (Voxgig::Struct::ismap($h) ? $h : {}),
    body        => VoxgigSolardemoHelpers::gp($resmap, 'body'),
    err         => VoxgigSolardemoHelpers::gp($resmap, 'err'),
    resdata     => VoxgigSolardemoHelpers::gp($resmap, 'resdata'),
    resmatch    => (Voxgig::Struct::ismap($rm) ? $rm : undef),
    paging      => undef,
    streaming   => undef,
    stream      => undef,
  }, $class;
}

1;
