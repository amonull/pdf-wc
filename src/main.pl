#!/usr/bin/perl

use warnings;
use strict;

use Getopt::Long qw(GetOptions);

use CAM::PDF;
use CAM::PDF::PageText;

my @ignore_pages = ();
my $count_lines = 0;
my $print_help = 0;
GetOptions( "ignore-pages|i=i{,}" => \@ignore_pages,
            "count-lines|l" => \$count_lines,
            "help|h" => print_usage() ) or die print_usage();

my $break_point = $count_lines ? '\n' : ' ';

sub print_usage {
  print "Usage: \[option\] \[file name(s)\]" . "\n";
  print "\n";
  print "Options:\n";
  print "\t" . "-i, --ignore-pages <num(s)>" . "\n";
  print "\t\t" . "pages to ignore" . "\n";
  print "\t" . "-l, --count-lines" . "\n";
  print "\t\t" . "count lines instead of words" . "\n";
  print "\t" . "-h, --help" . "\n";
  print "\t\t" . "shows this" . "\n";
 
  exit;
}

sub count_all_pages($) {

  my $pdf = CAM::PDF->new($_[0]);

  if (!$pdf) {
    return -1;
  }

  my $total_pdf_pages = $pdf->numPages;

  my $return_count = 0;
  foreach my $num (1..$total_pdf_pages) {
    # TODO: remove grep with a more efficinet/faster way to check if item is in @ignore_pages
    if (@ignore_pages && grep /^$num$/, @ignore_pages) {
      next;
    }
    my @read_page = split $break_point, CAM::PDF::PageText->render($pdf->getPageContentTree($num));
    $return_count += scalar @read_page;
  }

  return $return_count;
}

foreach my $pdf_path (@ARGV) {
  if ( !(-e $pdf_path) ) {
    print "File does not exists skipping $pdf_path \n";
    next;
  }

  my $result = count_all_pages($pdf_path);
  if ($result lt 0) {
    print "$pdf_path could not be read. File most likely not a pdf file. skipping";
    next;
  }

  print $result . "\n";
}
