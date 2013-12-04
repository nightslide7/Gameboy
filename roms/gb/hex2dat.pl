#- Bin2Hex.pl
#- Copyright (c) 1995 by Dr. Herong Yang, http://www.herongyang.com/
#
   ($in, $out) = @ARGV;
   die "Missing input file name.\n" unless $in;
   die "Missing output file name.\n" unless $out;
   $byteCount = 0;
   open(IN, "< $in");
   binmode(IN);
   open(OUT, "> $out");
   while (read(IN,$b,1)) {
      $n = length($b);
      $byteCount += $n;
      $s = 2*$n;
      print (OUT unpack("H$s", $b), "\n");
   }
   close(IN);
   close(OUT);
   print "Number of bytes converted = $byteCount\n";
   exit;

# Name to display in usage
$SCRIPT_NAME = "hex2dat.pl";

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
binmode $infile;
     
my $byte;
while (read($infile, $byte, 1)) {
    print ($byte);
}

close($infile);
close($outfile);

sub print_usage {
    print "Usage: perl $SCRIPT_NAME <input file> <output file>\n";
}
