#!/usr/bin/perl
package main;

use strict;
use warnings FATAL => 'all';
use utf8;
use open qw(:std :utf8);  # undeclared streams in UTF-8
use Data::Dumper;
use Getopt::Long;
use Pod::Usage;
use CAM::PDF;

our $VERSION = '0.1';
use constant mm => 25.4 / 72;

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
    print "pdf_fonts_tounicode.pl v$VERSION\n";
    exit 0;
}

if (@ARGV < 1)
{
    pod2usage(1);
}

my $filename = shift;
my $lut_filename = shift || "lut1.pl";
my $outfilename = shift || substr( $filename, 0, -4 )."+.pdf";

sub addPage
{
    my $self = shift;
    my $pagenum = shift;

    my $lastpage = $self->getPage($self->numPages());
    #print Data::Dumper->Dump([$lastpage]);
    my $page = $self->getPage($pagenum);
    my $objnum = $self->getPageObjnum($pagenum);
    my $newobjnum = $self->appendObject($self, $objnum, 0);
    my $newdict = $self->getObjValue($newobjnum);
    #$newdict
    delete $newdict->{Contents};
    # set parent from last page
    $newdict->{Parent}->{value} = $lastpage->{Parent}->{value};
    my $parent = $self->getValue($lastpage->{Parent});
    # set fixed page size MediaBox = A4 [0, 0, 595, 842]
    $newdict->{MediaBox}->{value}[2]->{value} = '595';
    $newdict->{MediaBox}->{value}[3]->{value} = '842';
    #print Data::Dumper->Dump([$newdict->{MediaBox}->{value}]);
    push @{$self->getValue($parent->{Kids})}, CAM::PDF::Node->new('reference', $newobjnum);

    while ($parent)
    {
        $self->{changes}->{$parent->{Count}->{objnum}} = 1;
        if ($parent->{Count}->{type} eq 'reference')
        {
            my $countobj = $self->dereference($parent->{Count}->{value});
            $countobj->{value}->{value}++;
            $self->{changes}->{$countobj->{objnum}} = 1;
        }
        else
        {
            $parent->{Count}->{value}++;
        }
        $parent = $self->getValue($parent->{Parent});
    }
    $self->{PageCount}++;

    # Caches are now bad for all pages from this one
    $self->decachePages($pagenum + 1 .. $self->numPages());
    return $self;
}

# Start with a PDF page (new or opened)
my $pdf = CAM::PDF->new($filename) || die "$CAM::PDF::errstr\n";

my $num_pages = $pdf->numPages();
my $helv_font_name = "HELVETICA+H0";
my $lut = <<END;
use strict;
use warnings FATAL => 'all';
use utf8;

# http://www.fileformat.info/info/unicode/index.htm
# http://unicode-table.com/ru/
#
# may by single symbol or hex code <0000>
#
# used symbols:
# COPYRIGHT SIGN                <00a9>
# WHITE SMILING FACE            <263a>
#
# additional symbols:
# LEFT-POINTING DOUBLE ANGLE QUOTATION MARK  <00ab>
# RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK <00bb>
# LEFT SINGLE QUOTATION MARK    <2018>
# RIGHT SINGLE QUOTATION MARK   <2019>
# LEFT DOUBLE QUOTATION MARK    <201c>
# RIGHT DOUBLE QUOTATION MARK 	<201d>
#
# EN DASH						<2013>
# EM DASH						<2014>
#
# ONE DOT LEADER				<2024>
# TWO DOT LEADER				<2025>
# HORIZONTAL ELLIPSIS			<2026>
#
# Greek Small Letter Pi			<03c0>
#
# may replace all quotation mark with simple ' and "

END

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

# обход всех страниц
my %fontsdone;
print "NumPages: $num_pages\n";
for my $pagenum (1 .. $num_pages)
{
    foreach my $fontname (sort $pdf->getFontNames( $pagenum ))
    {
        next if $fontname eq $helv_font_name;
        my $ctx = "";
        my $font = $pdf->getFont( $pagenum, $fontname );
        next if $fontsdone{$font};
        my $base_font_name = $pdf->getValue($font->{BaseFont});
        print "Font name: $fontname\nBase font: $base_font_name\n";
        $fontsdone{$font} = 1;

        $lut .= "\# BaseFont: $base_font_name\n";
        $lut .= "use vars qw (%$fontname);\n";
        $lut .= "%$fontname = (\n";

        my $indent = 28;
        # copy current page with all fonts
        addPage($pdf, $pagenum);

        # ToUnicode from embedded font
        my $U = $pdf->getValue( $font->{ToUnicode} );
        print "ToUnicode not exists\n" unless $U;
        my $us = $pdf->decodeOne( CAM::PDF::Node->new( 'dictionary', $U ) );
        #print $us;
        my %uni = ();
        my @L1 = split( "\n", $us );
        for (my $i = 0; $i < @L1; $i++)
        {
            if (index( $L1[$i], "beginbfrange" ) != -1)
            {
                my $n = (split / /, $L1[$i])[0];
                for (my $j = $i + 1; $j <= $i + $n; $j++)
                {
                    #print "$L1[$j]\n";
                    (my $a, my $b, my $c) = split / /, join('> <', split('><', $L1[$j]));
                    #print "$a\n";
                    my $m = 0;
                    for (my $k = hex substr $a, 1, 2; $k <= hex substr $b, 1, 2; $k++)
                    {
                        $uni{hex( substr( $a, 1, 2 ) ) + $m} = hex( substr( $c, 1, 4 ) ) + $m;
                        $m++
                    }
                }
            };
            if (index( $L1[$i], "beginbfchar" ) != -1)
            {
                my $n = (split / /, $L1[$i])[0];
                for (my $j = $i + 1; $j <= $i + $n; $j++)
                {
                    (my $a, my $c) = split( " ", $L1[$j] );
                    $uni{hex( substr( $a, 1, 2 ) )} = hex( substr( $c, 1, 4 ) );
                }
            }
        };

        my $page_n = $pdf->numPages();
        #print "Page_n: $page_n\n";
        #print Data::Dumper->Dump([$font->{ToUnicode}]);

        $ctx .= "BT\n1 0 0 1 $indent 800 Tm\n";
        my $lc = $pdf->getValue( $font->{LastChar} );
        my $fc = $pdf->getValue( $font->{FirstChar} );
        $ctx .= "/$helv_font_name 10 Tf\n";
        $ctx .= "[ ($fontname $fc $lc) ] TJ\n";
        $ctx .= "0 -12 Td\n";

        # print font gliph table
        for (my $i = $fc, my $no = 0; $i <= $lc; $i++, $no++) {
            $ctx .= "/$helv_font_name 10 Tf\n";
            my $uc = exists($uni{$i}) ? $uni{$i} : 0;
            $ctx .= sprintf(" (%i: <%x> <%04x> )  Tj\n", $i, $i, $uc);
            $ctx .= "/$fontname  10  Tf\n";

            # problem with ( and ) in the string need slash
            my $str = sprintf("%s", chr($i));
            $str =~ s/([\n\r\t\b\f\\()])/\\$out_trans{$1}/ogi;
            $ctx .= "($str) Tj\n 0 -12 Td\n";
            $lut .= sprintf("\t%i => '',\n", $i);

            # next column
            if ($no > 60){
                $indent += 120;
                $ctx .= "ET\n";
                $ctx .= "BT\n1 0 0 1 $indent 800 Tm\n";
                $ctx .= "0 -12 Td\n";
                $no = 0;
            }
        }
        $ctx .= "ET\n";
        $lut .= ");\n\n";

        $pdf->setPageContent($page_n, $ctx);

        $pdf->addFont($page_n,  "Helvetica", $helv_font_name);
        # update resources object
        $pdf->{changes}->{$pdf->getPage($page_n)->{Resources}->{value}} = 1;
    }
}

# Save the PDF
$pdf->output($outfilename) || die "$CAM::PDF::errstr\n";

open(my $fh, '>:encoding(UTF-8)', $lut_filename)
    or die "Could not open file '$lut_filename'";
print $fh $lut;
close($fh);

print "OK\n";

__END__

=head1 NAME

pdf_fonts_tounicode.pl - add to the end of PDF file pages with font gliphs

=head1 SYNOPSIS

 pdf_fonts_tounicode.pl [options] infile.pdf [lutfile.pl] [outfile.pdf]

 Options:
   -h --help           verbose help message
   -V --version        print CAM::PDF version

=head1 DESCRIPTION

Add to the end of file pages with embedded font gliphs. Create file with templates
for the ToUnicode encoding.

Default F<lutfile.pl> - lut1.pl.

Default F<outfile.pdf> - {infile}+.pdf.

=head1 AUTHOR

S.Volkov, sv99@inbox.ru

=cut