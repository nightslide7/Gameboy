# Name to display in usage
$SCRIPT_NAME = "dat2hex.pl";

my $argc = @ARGV;

if ($argc != 2) {
    print_usage();
    exit(0);
}

my $infile;
my $outfile;

$infileName = $ARGV[0];
$outfileName = $ARGV[1];

open($infile, "<", $infileName) || die("Couldn't open $infileName ", $!);
open($outfile, ">", $outfileName) || die("Couldn't open $outfileDatName ",
     $!);
     
my $line;
while (<$infile>) {
    chomp;
    $line = $_;
    #print ($line);
    print $outfile "$line$line\n";
}

close($infile);
close($outfile);

sub print_usage {
    print "Usage: perl $SCRIPT_NAME <input file> <output file>\n";
}