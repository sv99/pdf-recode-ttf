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

# BaseFont: PCVAJI+TimesNewRomanPSMT
use vars qw (%TT2);
%TT2 = (
	33 => '',
	34 => '',
	35 => '',
	36 => '',
	37 => '',
	38 => '',
	39 => '',
	40 => '',
	41 => '',
	42 => '',
	43 => '',
	44 => '',
	45 => '',
	46 => '',
	47 => '',
	48 => '',
	49 => '',
	50 => '',
	51 => '',
	52 => '',
	53 => '',
	54 => '',
	55 => '',
	56 => '',
	57 => '',
	58 => '',
	59 => '',
	60 => '',
	61 => '',
	62 => '',
	63 => '',
	64 => '',
	65 => '',
	66 => '',
	67 => '',
	68 => '',
	69 => '',
	70 => '',
	71 => '',
	72 => '',
	73 => '',
	74 => '',
	75 => '',
	76 => '',
	77 => '',
	78 => '',
	79 => '',
	80 => '',
	81 => '',
	82 => '',
	83 => '',
	84 => '',
	85 => '',
	86 => '',
	87 => '',
	88 => '',
	89 => '',
	90 => '',
	91 => '',
);

# BaseFont: GJWIES+TimesNewRomanPS-BoldMT
use vars qw (%TT4);
%TT4 = (
	33 => '',
	34 => '',
	35 => '',
);

