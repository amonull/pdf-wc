#!/usr/bin/perl

use warnings;
use strict;

use CAM::PDF;
use CAM::PDF::PageText;

my $pdf = CAM::PDF->new("/home/amon/Documents/lectures/oop/main-assignment-report/report-ver0_1.pdf");
my $total_pdf_pages = $pdf->numPages;

sub count_all_pages() {
  my $return_count = 0;
  foreach my $num (1..$total_pdf_pages) {
    my @read_page = split(' ', CAM::PDF::PageText->render($pdf->getPageContentTree($num)));
    $return_count += scalar @read_page;
  }

  return $return_count;
}

my $word_count_on_all = count_all_pages();

print $word_count_on_all . "\n";
