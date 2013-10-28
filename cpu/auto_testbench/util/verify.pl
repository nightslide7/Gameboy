# Name to display in usage
$SCRIPT_NAME = "verify.pl";

my $argc = @ARGV;

if ($argc != 3) {
    print_usage();
    exit(0);
}

my $keyfile;
my $regfile;
my $cpufile;
my $infileName;
my $outfileName;

$keyfileName = $ARGV[0];
$regfileName = $ARGV[1];
$cpufileName = $ARGV[2];

open($keyfile, "<", $keyfileName) || die("Couldn't open $keyfileName", $!);
open($regfile, "<", $regfileName) || die("Couldn't open $regfileName", $!);
open($cpufile, "<", $cpufileName) || die("Couldn't open $cpufileName", $!);

# Format: AF NNNN\n BC NNNN\n DE NNNN\n HL NNNN\n SP NNNN\n PC NNNN\n
my %keyRegisters = (
    "AF" => "XXXX",
    "BC" => "XXXX",
    "DE" => "XXXX",
    "HL" => "XXXX",
    "SP" => "XXXX",
    "PC" => "XXXX",
    );
my %simRegisters = (
    "AF" => "XXXX",
    "BC" => "XXXX",
    "DE" => "XXXX",
    "HL" => "XXXX",
    "SP" => "XXXX",
    "PC" => "XXXX",
    );
my $line;
while (<$keyfile>) {
    if ($_ =~ /^([A-S]{2})\ {1}([0-9,A-F,a-f]{4})/ && 
        exists($keyRegisters{$1})) {
        $keyRegisters{$1} = $2;
    }
}

while (<$regfile>) {
    if ($_ =~ /^([A-S]{2})\ {1}([0-9,A-F,a-f]{4})/ && 
        exists($simRegisters{$1})) {
        $simRegisters{$1} = $2;
    }
}

while (<$cpufile>) {
    if ($_ =~ /^([A-S]{2})\ {1}([0-9,A-F,a-f]{4})/ &&
        exists($simRegisters{$1})) {
        $simRegisters{$1} = $2;
    }
}

close($keyfile);
close($regfile);
close($cpufile);

# print "\nKey registers parsed as:\n";
# while (($reg, $value) = each %keyRegisters) {
#     print "$reg $value\n";
# }

# print "\nSimulation registers parsed as:\n";
# while (($reg, $value) = each %simRegisters) {
#     print "$reg $value\n";
# }

my @regs = keys %simRegisters;
@regs = sort @regs;

print "RN  key  sim\n";
my $keyRegVal;
my $simRegVal;
my $suffix;
foreach my $reg (@regs) {
    $keyRegVal = $keyRegisters{$reg};
    $simRegVal = $simRegisters{$reg};
    if (hex($keyRegVal) == hex($simRegVal)) {
        $suffix = "ok";
    } else {
        $suffix = "shit";
    }
    print "$reg $keyRegVal $simRegVal $suffix\n";
}

sub print_usage {
    print("Usage: perl $SCRIPT_NAME <expected output> <reg sim out> " .
          "<cpu sim out>\n");
}
