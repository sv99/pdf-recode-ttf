#!/usr/bin/perl -w
#line 2 "pdf-recode.pl"
# Created by Vadim Repin. This is free software, you may use it as you see fit.

use warnings;
use strict;
use CAM::PDF;

my $skip_dings_and_symbols = 1; # Don't want cyrillics pop up in place of bullets, etc. Poorly implemented.
# my $try_greek_way = 0;          # Not implemented. Always false.
my $use_yat_hack = 1;           # Set to "0" if belarussian.
my $use_mighty_hack1 = 1;       # Works if you are Antabu with a weird file, but shouldn't hurt anyone else.
my $use_mighty_hack2 = 1;       # Shouldn't hurt either.
my $use_magick = 1;             # Don't touch. Don't ask. You'll live longer.
# my $always_prefer_encoding = 1; # Not implemented. Does nothing.
my $use_mighty_hack3 = 1;       # Yet another mighty hack... For "Advn*" fonts...

die "gimme a file!" if ($#ARGV == -1);

my $filename = $ARGV[0];
my $doc;
eval { $doc = CAM::PDF->new( $filename ) || die };

die "what's wrong with this file?" if ($@);

my %CP1251 = do 'cp1251.pl';
my %CP1252 = do 'cp1252.pl';
my %WAEN = do 'win_ansii_enc_names.pl';
my %AW2CYR = do 'aw2_plus_cyr.pl';
my %rCP1252 = reverse %CP1252;
my %rWAEN = reverse %WAEN;                     # will do...
my %rAW2CYR = reverse %AW2CYR;
my %H3 = do 'H3.pl';

if ($use_yat_hack)
{
    $CP1251{"<A2>"} = "<0463>"
};

my %LUT = ();
if ($use_mighty_hack1)
{
    %LUT = do 'lut.pl'
};

my %LUT4 = ();
if ($use_mighty_hack2)
{
    %LUT4 = (
        "g3", "<0020>",
        "glyph192", "<0443>",
        "glyph179", "<043A>",
        "glyph146", "<0433>"
    )
};

my $CMapHeader = <<END;
/CIDInit /ProcSet findresource begin 12 dict begin begincmap /CIDSystemInfo <<
/Registry (test) /Ordering (T1UV) /Supplement 0 >> def
/CMapName /test def
/CMapType 2 def
1 begincodespacerange <00> <ff> endcodespacerange
END

sub hash_cmp (\%\%)
{
    my ($h1, $h2) = @_;
    my %hash1 = %$h1;
    my %hash2 = %$h2;
    foreach (keys %hash1) {
        return 1 unless defined $hash2{$_} and $hash1{$_} eq $hash2{$_};
        delete $hash1{$_};
        delete $hash2{$_};
    }
    return 1 if keys %hash2;
    return 0;
};

my %fontsdone;
my $changed;
my $num_pages = $doc->numPages();

print "NumPages: $num_pages\n";
for my $p (1 .. $num_pages)
{
    foreach my $fontname (sort $doc->getFontNames( $p ))
    {
        my $font = $doc->getFont( $p, $fontname );
        next if $fontsdone{$font};
        print "Font name: $fontname\n";
        $fontsdone{$font} = 1;

        my ($anyobj) = values %{$font};
        my $n = $anyobj->{objnum};
        next unless $n;

        my $bf = $doc->getValue( $font->{BaseFont} );
        print "Base Font: $bf\n";
        if ($skip_dings_and_symbols)
        {
            next if ($bf =~ /ding/i);
            next if ($bf =~ /symbol/i);
            next if ($bf =~ /greek/i)
        };

        my $lc = $doc->getValue( $font->{LastChar} );
        print "LastChar: $lc\n";
        next unless $lc;
        my $fc = $doc->getValue( $font->{FirstChar} );
        print "FirstChar: $fc\n";

        my $E = $font->{Encoding};
        print "Encoding not exists\n" unless $E;
        my $U = $doc->getValue( $font->{ToUnicode} );
        print "ToUnicode not exists\n" unless $U;
        next unless $E || $U;

        my %enc;
        my %uni;

        if ($E)
        {
            if ($E->{type} eq 'label')
            {
                if ($doc->getValue( $E ) eq 'WinAnsiEncoding')
                {
                    %enc = %WAEN
                }
                else
                {
                    next
                }
            };
            if ($E->{type} eq 'reference')
            {
                my $ref = $doc->getValue( $E );
                if ($ref->{BaseEncoding})
                {
                    if ($doc->getValue( $ref->{BaseEncoding} ) eq 'WinAnsiEncoding')
                    {
                        %enc = %WAEN
                    }
                    else
                    {
                        next
                    }
                }
                else
                {
                    %enc = %WAEN
                }
                ;
                if ($ref->{Differences})
                {
                    my @diffs = @{$doc->getValue( $ref->{Differences} )};
                    my $i = 0;
                    foreach (@diffs)
                    {
                        if ($_->{type} eq 'number')
                        {
                            $i = $_->{value}
                        }
                        else
                        {
                            $enc{sprintf( "<%02X>", $i )} = $_->{value};
                            $i++
                        }
                    };
                    my $G = 1;          # G-spot?
                    foreach (keys %enc)
                    {
                        if (!($enc{$_} =~ /^G../))
                        {
                            $G = 0;
                            last
                        }
                    };
                    if ($G)
                    {
                        foreach (keys %enc)
                        {
                            my $s = '<'.substr( $enc{$_}, 1, 2 ).'>';
                            $enc{$_} = $WAEN{$s}
                        }
                    }
                }
            }
        };

        if (($use_mighty_hack3) && ($bf =~ /Advn/)) { %enc = %H3 };

        if ($U)
        {
            my $s = $doc->decodeOne( CAM::PDF::Node->new( 'dictionary', $U ) );
            print $s;
            my @L1 = split( "\n", $s );
            for (my $i = 0; $i < @L1; $i++)
            {
                if (index( $L1[$i], "beginbfrange" ) != -1)
                {
                    my $n = (split / /, $L1[$i])[0];
                    for (my $j = $i + 1; $j <= $i + $n; $j++)
                    {
                        print "$L1[$j]\n";
                        (my $a, my $b, my $c) = split / /, join('> <', split('><', $L1[$j]));
                        print "$a\n";
                        my $m = 0;
                        for (my $k = hex substr $a, 1, 2; $k <= hex substr $b, 1, 2; $k++)
                        {
                            $uni{sprintf( "<%02X>", hex( substr( $a, 1, 2 ) ) + $m )} = sprintf( "<%04X>",
                                hex( substr( $c, 1, 4 ) ) + $m );
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
                        $uni{sprintf( "<%02X>", hex( substr( $a, 1, 2 ) ) )} = sprintf( "<%04X>",
                            hex( substr( $c, 1, 4 ) ) );
                    }
                }
            };
            my %old_uni = %uni;

            if (grep($_ eq "<F8FF>", values %uni) != 0)
            {
                foreach (keys %uni)
                {
                    if ($LUT{$uni{$_}})
                    {
                        $uni{$_} = $LUT{$uni{$_}}
                    }
                }
            };
            foreach (keys %uni)
            {
                my $a = $rCP1252{$uni{$_}};
                if ($a)
                {
                    $uni{$_} = $CP1251{$a}
                }
            };
            foreach (keys %enc)
            {
                if ($LUT4{$enc{$_}})
                {
                    $uni{$_} = $LUT4{$enc{$_}}
                }
            };
            next unless hash_cmp( %uni, %old_uni )
        }
        else
        {
            if (($use_magick) && ((keys %enc == 224) || (keys %enc == 225)
                || ($lc - $fc == 224) || ($lc - $fc == 223)))
            {
                %uni = %CP1251
            }
            else
            {
                foreach (keys %enc)
                {
                    if (defined $rWAEN{$enc{$_}})
                    {
                        $uni{$_} = $CP1251{$rWAEN{$enc{$_}}}
                    }
                    else
                    {
                        if (defined $rAW2CYR{$enc{$_}})
                        {
                            $uni{$_} = $rAW2CYR{$enc{$_}}
                        }
                        else
                        {
                            if ($enc{$_} =~ /^uni..../)
                            {
                                $uni{$_} = '<'.substr( $enc{$_}, 3 ).'>'
                            }
                            else
                            {
                                $uni{$_} = '<FFFD>'
                            }
                        }
                    }
                }
            }
        };

        my $s = $CMapHeader.(keys %uni)." beginbfchar\n";
        foreach (sort keys %uni)
        {
            $s .= $_." ".$uni{$_}."\n"
        };
        $s .= "endbfchar\nendcmap CMapName currentdict /CMap defineresource pop end end\n";
        $s =~ s/test/$bf+0/g;
        my $stream = $doc->createStreamObject( $s, 'FlateDecode' );

        if ($U)
        {
            my $key = $font->{ToUnicode}->{value};
            $doc->replaceObject( $key, undef, $stream, 0 );
        }
        else
        {
            my $key = $doc->appendObject( undef, $stream, 0 );
            $font->{ToUnicode} = CAM::PDF::Node->new( 'reference', $key );
            $doc->{changes}->{$n} = 1;
        };
        $changed = 1
    }
};

die "nothing to fix!" if (!$changed);

eval { $doc->output( substr( $filename, 0, -4 )."+.pdf" ) };
die "can't save!" if ($@);

print "OK";
