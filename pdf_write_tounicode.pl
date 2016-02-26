#!/usr/bin/perl
package main;

use strict;
no strict 'refs';
use warnings FATAL => 'all';
use utf8;
use open qw(:std :utf8);  # undeclared streams in UTF-8
use Data::Dumper;
use Getopt::Long;
use Pod::Usage;
use CAM::PDF;

our $VERSION = '0.1';

my %opts = (
    help       => 0,
    version    => 0,
);

Getopt::Long::Configure('bundling');
GetOptions(
    'h|help'     => \$opts{help},
    'V|version'  => \$opts{version},
) or pod2usage(1);
if ($opts{help})
{
    pod2usage(-exitstatus => 0, -verbose => 2);
}
if ($opts{version})
{
    print "pdf_write_tounicode.pl v$VERSION\n";
    exit 0;
}

if (@ARGV < 1)
{
    pod2usage(1);
}

my $filename = shift;
my $lut_filename = shift || "lut2.pl";
my $outfilename = shift || substr( $filename, 0, -4 )."+U.pdf";

#eval ("use $lut_filename");
require "$lut_filename.pl";

# Start with a PDF page (new or opened)
my $pdf = CAM::PDF->new($filename) || die "$CAM::PDF::errstr\n";

our %out_trans = (
    "\n" => 'n',
    "\r" => 'r',
    "\t" => 't',
    "\b" => 'b',
    "\f" => 'f',
    "\\" => "\\",
    '(' => '(',
    ')' => ')',
);

my $CMapHeader = <<END;
/CIDInit /ProcSet findresource begin 12 dict begin begincmap /CIDSystemInfo <<
/Registry (test) /Ordering (T1UV) /Supplement 0 >> def
/CMapName /test def
/CMapType 2 def
1 begincodespacerange <00> <ff> endcodespacerange
END

# обход всех страниц
my %fontsdone;
my $num_pages = $pdf->numPages();
print "NumPages: $num_pages\n";
for my $pagenum (1 .. $num_pages)
{
    foreach my $fontname (sort $pdf->getFontNames( $pagenum ))
    {
        my $ctx = "";
        my $font = $pdf->getFont( $pagenum, $fontname );
        next if $fontsdone{$font};
        print "Font name: $fontname\n";
        $fontsdone{$font} = 1;

        # ToUnicode from embedded font
        my $uni = <<END;
/CIDInit /ProcSet findresource begin 12 dict begin begincmap /CIDSystemInfo <<
/Registry (Adobe) /Ordering (UCS) /Supplement 0 >> def
/CMapName /Adobe-Identity-UCS def
/CMapType 2 def
1 begincodespacerange <00> <ff> endcodespacerange
END
#        my %U = %{$fontname};
#        eval "%U = %$fontname";
#        print %TT10;
#        print Data::Dumper->Dump([%{$fontname}]);
        $uni .= (keys %{$fontname})." beginbfchar\n";
        foreach (sort keys %{$fontname})
        {
            my $val = length ${$fontname}{$_} > 1 ? hex( substr( ${$fontname}{$_} , 1, 4 ) ) : ord(${$fontname}{$_});
            $uni .= sprintf("<%02x> <%04x>\n", $_, $val);
        };
        $uni .= "endbfchar\nendcmap CMapName currentdict /CMap defineresource pop end end\n";
        print $uni;
        my $stream = $pdf->createStreamObject( $uni, 'FlateDecode' );

        my $key = $font->{ToUnicode}->{value};
        $pdf->replaceObject( $key, undef, $stream, 0 );
    }
}

# Save the PDF
$pdf->output($outfilename) || die "$CAM::PDF::errstr\n";

print "OK\n";

__END__

=head1 NAME

pdf_write_tounicode.pl - add ToUnicode field to the embedded fonts with data from lutfile.

=head1 SYNOPSIS

 pdf_write_tounicode.pl [options] infile.pdf [lutfile.pl] [outfile.pdf]

 Options:
   -h --help           verbose help message
   -V --version        print CAM::PDF version

=head1 DESCRIPTION

Add ToUnicode field to the embedded fonts with data from lutfile.

Default F<lutfile.pl> - lut2.pl.

Default F<outfile.pdf> - {infile}+U.pdf.

=head1 AUTHOR

S.Volkov, sv99@inbox.ru

=cut