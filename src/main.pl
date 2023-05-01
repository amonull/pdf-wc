#!/usr/bin/perl

use warnings;
use strict;

use CAM::PDF;
use CAM::PDF::PageText;

my $pdf = CAM::PDF->new("/home/amon/Documents/lectures/oop/main-assignment-report/report-ver0_1.pdf");
my $total_pdf_pages = $pdf->numPages;
my $break_point = ' '; # for reading words
# my $break_point = '\n'; # for reading lines
my @ignore_pages = qw(1 2);

sub count_all_pages() {
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

my $word_count_on_all = count_all_pages();

print $word_count_on_all . "\n";
