# Name to display in usage
$SCRIPT_NAME = "raw.pl";
# Number of bytes in a GB ROM
$ROM_BYTES = 32768;

my $argc = @ARGV;

if ($argc != 3) {
    print_usage();
    exit(0);
}

my $infile;
my $outfileDat;
my $outfileHex;
my $infileName;
my $outfileDatName;
my $outfileHexName;

$infileName = $ARGV[0];
$outfileDatName = $ARGV[1];
$outfileHexName = $ARGV[2];

open($infile, "<", $infileName) || die("Couldn't open $infileName", $!);
open($outfileDat, ">", $outfileDatName) || die("Couldn't open $outfileDatName",
     $!);
open($outfileHex, ">", $outfileHexName) || die("Couldn't open $outfileHexName",
     $!);

my $line;
my $hex1;
my $hex2;
my $hex3;
my $bytes = 0;
while (<$infile>) {
    chomp;
    $line = $_;
    if ($line =~ /^\ {3}[0-9,A-F]{4}\ ([0-9,A-F]{2})\ ([0-9,A-F]{2})\ ([0-9,A-F]{2})/) {
        $hex1 = chr(hex($1));
        $hex2 = chr(hex($2));
        $hex3 = chr(hex($3));
        #print "$1, $2, $3; $line\n";
        print $outfileDat "$1\n$2\n$3\n";
        print $outfileHex "$hex1$hex2$hex3";
        $bytes += 3;
    } elsif ($line =~ /^\ {3}[0-9,A-F]{4}\ ([0-9,A-F]{2})\ ([0-9,A-F]{2})/) {
        $hex1 = chr(hex($1));
        $hex2 = chr(hex($2));
        #print "$1, $2; $line\n";
        print $outfileDat "$1\n$2\n";
        print $outfileHex "$hex1$hex2$hex3";
        $bytes += 2;
    } elsif ($line =~ /^\ {3}[0-9,A-F]{4}\ ([0-9,A-F]{2})/) {
        $hex1 = chr(hex($1));
        #print "$1; $line\n";
        print $outfileDat "$1\n";
        print $outfileHex "$hex1";
        $bytes ++;
    }
}

while ($bytes < $ROM_BYTES) {
    print $outfileHex chr(0);
    $bytes ++;
}

close($infile);
close($outfileDat);
close($outfileHex);

sub print_usage {
    print "Usage: perl $SCRIPT_NAME <input file> <output file dat> <output file hex>\n";
}
