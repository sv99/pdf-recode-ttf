use strict;
use warnings FATAL => 'all';

#This text file shows Unicodes and glyph names for the Adobe Western 2 + Adobe Cyrillic character set.
#--- [code]=<name/CID>
(
"<0020>", "space", 
"<0021>", "exclam", 
"<0022>", "quotedbl", 
"<0023>", "numbersign", 
"<0024>", "dollar", 
"<0025>", "percent", 
"<0026>", "ampersand", 
"<0027>", "quotesingle", 
"<0028>", "parenleft", 
"<0029>", "parenright", 
"<002A>", "asterisk", 
"<002B>", "plus", 
"<002C>", "comma", 
"<002D>", "hyphen", 
"<002E>", "period", 
"<002F>", "slash", 
"<0030>", "zero", 
"<0031>", "one", 
"<0032>", "two", 
"<0033>", "three", 
"<0034>", "four", 
"<0035>", "five", 
"<0036>", "six", 
"<0037>", "seven", 
"<0038>", "eight", 
"<0039>", "nine", 
"<003A>", "colon", 
"<003B>", "semicolon", 
"<003C>", "less", 
"<003D>", "equal", 
"<003E>", "greater", 
"<003F>", "question", 
"<0040>", "at", 
"<0041>", "A", 
"<0042>", "B", 
"<0043>", "C", 
"<0044>", "D", 
"<0045>", "E", 
"<0046>", "F", 
"<0047>", "G", 
"<0048>", "H", 
"<0049>", "I", 
"<004A>", "J", 
"<004B>", "K", 
"<004C>", "L", 
"<004D>", "M", 
"<004E>", "N", 
"<004F>", "O", 
"<0050>", "P", 
"<0051>", "Q", 
"<0052>", "R", 
"<0053>", "S", 
"<0054>", "T", 
"<0055>", "U", 
"<0056>", "V", 
"<0057>", "W", 
"<0058>", "X", 
"<0059>", "Y", 
"<005A>", "Z", 
"<005B>", "bracketleft", 
"<005C>", "backslash", 
"<005D>", "bracketright", 
"<005E>", "asciicircum", 
"<005F>", "underscore", 
"<0060>", "grave", 
"<0061>", "a", 
"<0062>", "b", 
"<0063>", "c", 
"<0064>", "d", 
"<0065>", "e", 
"<0066>", "f", 
"<0067>", "g", 
"<0068>", "h", 
"<0069>", "i", 
"<006A>", "j", 
"<006B>", "k", 
"<006C>", "l", 
"<006D>", "m", 
"<006E>", "n", 
"<006F>", "o", 
"<0070>", "p", 
"<0071>", "q", 
"<0072>", "r", 
"<0073>", "s", 
"<0074>", "t", 
"<0075>", "u", 
"<0076>", "v", 
"<0077>", "w", 
"<0078>", "x", 
"<0079>", "y", 
"<007A>", "z", 
"<007B>", "braceleft", 
"<007C>", "bar", 
"<007D>", "braceright", 
"<007E>", "asciitilde", 
"<00A0>", "uni00A0", 
"<00A1>", "exclamdown", 
"<00A2>", "cent", 
"<00A3>", "sterling", 
"<00A4>", "currency", 
"<00A5>", "yen", 
"<00A6>", "brokenbar", 
"<00A7>", "section", 
"<00A8>", "dieresis", 
"<00A9>", "copyright", 
"<00AA>", "ordfeminine", 
"<00AB>", "guillemotleft", 
"<00AC>", "logicalnot", 
"<00AD>", "uni00AD", 
"<00AE>", "registered", 
"<00AF>", "macron", 
"<00B0>", "degree", 
"<00B1>", "plusminus", 
"<00B2>", "two.superior", 
"<00B3>", "three.superior", 
"<00B4>", "acute", 
"<00B5>", "mu", 
"<00B6>", "paragraph", 
"<00B7>", "periodcentered", 
"<00B8>", "cedilla", 
"<00B9>", "one.superior", 
"<00BA>", "ordmasculine", 
"<00BB>", "guillemotright", 
"<00BC>", "onequarter", 
"<00BD>", "onehalf", 
"<00BE>", "threequarters", 
"<00BF>", "questiondown", 
"<00C0>", "Agrave", 
"<00C1>", "Aacute", 
"<00C2>", "Acircumflex", 
"<00C3>", "Atilde", 
"<00C4>", "Adieresis", 
"<00C5>", "Aring", 
"<00C6>", "AE", 
"<00C7>", "Ccedilla", 
"<00C8>", "Egrave", 
"<00C9>", "Eacute", 
"<00CA>", "Ecircumflex", 
"<00CB>", "Edieresis", 
"<00CC>", "Igrave", 
"<00CD>", "Iacute", 
"<00CE>", "Icircumflex", 
"<00CF>", "Idieresis", 
"<00D0>", "Eth", 
"<00D1>", "Ntilde", 
"<00D2>", "Ograve", 
"<00D3>", "Oacute", 
"<00D4>", "Ocircumflex", 
"<00D5>", "Otilde", 
"<00D6>", "Odieresis", 
"<00D7>", "multiply", 
"<00D8>", "Oslash", 
"<00D9>", "Ugrave", 
"<00DA>", "Uacute", 
"<00DB>", "Ucircumflex", 
"<00DC>", "Udieresis", 
"<00DD>", "Yacute", 
"<00DE>", "Thorn", 
"<00DF>", "germandbls", 
"<00E0>", "agrave", 
"<00E1>", "aacute", 
"<00E2>", "acircumflex", 
"<00E3>", "atilde", 
"<00E4>", "adieresis", 
"<00E5>", "aring", 
"<00E6>", "ae", 
"<00E7>", "ccedilla", 
"<00E8>", "egrave", 
"<00E9>", "eacute", 
"<00EA>", "ecircumflex", 
"<00EB>", "edieresis", 
"<00EC>", "igrave", 
"<00ED>", "iacute", 
"<00EE>", "icircumflex", 
"<00EF>", "idieresis", 
"<00F0>", "eth", 
"<00F1>", "ntilde", 
"<00F2>", "ograve", 
"<00F3>", "oacute", 
"<00F4>", "ocircumflex", 
"<00F5>", "otilde", 
"<00F6>", "odieresis", 
"<00F7>", "divide", 
"<00F8>", "oslash", 
"<00F9>", "ugrave", 
"<00FA>", "uacute", 
"<00FB>", "ucircumflex", 
"<00FC>", "udieresis", 
"<00FD>", "yacute", 
"<00FE>", "thorn", 
"<00FF>", "ydieresis", 
"<0131>", "dotlessi", 
"<0141>", "Lslash", 
"<0142>", "lslash", 
"<0152>", "OE", 
"<0153>", "oe", 
"<0160>", "Scaron", 
"<0161>", "scaron", 
"<0178>", "Ydieresis", 
"<017D>", "Zcaron", 
"<017E>", "zcaron", 
"<0192>", "florin", 
"<02C6>", "circumflex", 
"<02C7>", "caron", 
"<02C9>", "uni02C9", 
"<02D8>", "breve", 
"<02D9>", "dotaccent", 
"<02DA>", "ring", 
"<02DB>", "ogonek", 
"<02DC>", "tilde", 
"<02DD>", "hungarumlaut", 
"<03A9>", "uni03A9", 
"<03BC>", "uni03BC", 
"<03C0>", "pi", 
"<0401>", "afii10023", 
"<0402>", "afii10051", 
"<0403>", "afii10052", 
"<0404>", "afii10053", 
"<0405>", "afii10054", 
"<0406>", "afii10055", 
"<0407>", "afii10056", 
"<0408>", "afii10057", 
"<0409>", "afii10058", 
"<040A>", "afii10059", 
"<040B>", "afii10060", 
"<040C>", "afii10061", 
"<040E>", "afii10062", 
"<040F>", "afii10145", 
"<0410>", "afii10017", 
"<0411>", "afii10018", 
"<0412>", "afii10019", 
"<0413>", "afii10020", 
"<0414>", "afii10021", 
"<0415>", "afii10022", 
"<0416>", "afii10024", 
"<0417>", "afii10025", 
"<0418>", "afii10026", 
"<0419>", "afii10027", 
"<041A>", "afii10028", 
"<041B>", "afii10029", 
"<041C>", "afii10030", 
"<041D>", "afii10031", 
"<041E>", "afii10032", 
"<041F>", "afii10033", 
"<0420>", "afii10034", 
"<0421>", "afii10035", 
"<0422>", "afii10036", 
"<0423>", "afii10037", 
"<0424>", "afii10038", 
"<0425>", "afii10039", 
"<0426>", "afii10040", 
"<0427>", "afii10041", 
"<0428>", "afii10042", 
"<0429>", "afii10043", 
"<042A>", "afii10044", 
"<042B>", "afii10045", 
"<042C>", "afii10046", 
"<042D>", "afii10047", 
"<042E>", "afii10048", 
"<042F>", "afii10049", 
"<0430>", "afii10065", 
"<0431>", "afii10066", 
"<0432>", "afii10067", 
"<0433>", "afii10068", 
"<0434>", "afii10069", 
"<0435>", "afii10070", 
"<0436>", "afii10072", 
"<0437>", "afii10073", 
"<0438>", "afii10074", 
"<0439>", "afii10075", 
"<043A>", "afii10076", 
"<043B>", "afii10077", 
"<043C>", "afii10078", 
"<043D>", "afii10079", 
"<043E>", "afii10080", 
"<043F>", "afii10081", 
"<0440>", "afii10082", 
"<0441>", "afii10083", 
"<0442>", "afii10084", 
"<0443>", "afii10085", 
"<0444>", "afii10086", 
"<0445>", "afii10087", 
"<0446>", "afii10088", 
"<0447>", "afii10089", 
"<0448>", "afii10090", 
"<0449>", "afii10091", 
"<044A>", "afii10092", 
"<044B>", "afii10093", 
"<044C>", "afii10094", 
"<044D>", "afii10095", 
"<044E>", "afii10096", 
"<044F>", "afii10097", 
"<0451>", "afii10071", 
"<0452>", "afii10099", 
"<0453>", "afii10100", 
"<0454>", "afii10101", 
"<0455>", "afii10102", 
"<0456>", "afii10103", 
"<0457>", "afii10104", 
"<0458>", "afii10105", 
"<0459>", "afii10106", 
"<045A>", "afii10107", 
"<045B>", "afii10108", 
"<045C>", "afii10109", 
"<045E>", "afii10110", 
"<045F>", "afii10193", 
"<0462>", "afii10146", 
"<0463>", "afii10194", 
"<0472>", "afii10147", 
"<0473>", "afii10195", 
"<0474>", "afii10148", 
"<0475>", "afii10196", 
"<0490>", "afii10050", 
"<0491>", "afii10098", 
"<04D9>", "afii10846", 
"<2013>", "endash", 
"<2014>", "emdash", 
"<2018>", "quoteleft", 
"<2019>", "quoteright", 
"<201A>", "quotesinglbase", 
"<201C>", "quotedblleft", 
"<201D>", "quotedblright", 
"<201E>", "quotedblbase", 
"<2020>", "dagger", 
"<2021>", "daggerdbl", 
"<2022>", "bullet", 
"<2026>", "ellipsis", 
"<2030>", "perthousand", 
"<2039>", "guilsinglleft", 
"<203A>", "guilsinglright", 
"<2044>", "fraction", 
"<20AC>", "Euro", 
"<2113>", "afii61289", 
"<2116>", "afii61352", 
"<2122>", "trademark", 
"<2126>", "Omega", 
"<212E>", "estimated", 
"<2202>", "partialdiff", 
"<2206>", "Delta", 
"<220F>", "product", 
"<2211>", "summation", 
"<2212>", "minus", 
"<2215>", "uni2215", 
"<2219>", "uni2219", 
"<221A>", "radical", 
"<221E>", "infinity", 
"<222B>", "integral", 
"<2248>", "approxequal", 
"<2260>", "notequal", 
"<2264>", "lessequal", 
"<2265>", "greaterequal", 
"<25CA>", "lozenge", 
"<F6C5>", "afii10066.ital", 
"<F6C9>", "acute.cap", 
"<F6CA>", "caron.cap", 
"<F6CB>", "dieresis.cap", 
"<F6CC>", "space_uni0308_uni0301.cap", 
"<F6CD>", "space_uni0308_uni0300.cap", 
"<F6CE>", "grave.cap", 
"<F6CF>", "hungarumlaut.cap", 
"<F6D0>", "macron.cap", 
"<F6D1>", "breve.cyrcap", 
"<F6D2>", "circumflex.cyrcap", 
"<F6D3>", "space_uni030F", 
"<F6D4>", "breve.cyr", 
"<F6D5>", "circumflex.cyr", 
"<F6D6>", "space_uni030F.cap", 
"<F6D7>", "space_uni0308_uni0301", 
"<F6D8>", "space_uni0308_uni0300", 
"<FB01>", "f_i", 
"<FB02>", "f_l"
);
