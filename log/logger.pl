#!perl -w
  use Tail;

$tail = $ARGV[0] || 50;
$LOGFILE = "development.log";
\&tailFile($LOGFILE, $tail);

sub tailFile
{
    my ($filename, $numlines) = @_;
    print "Tailing last $numlines lines of file $filename\n";
    my $chunk = 300 * $numlines; #assume a <= 300 char line(generous)

    # Open the file in read mode
    open FILE, "<$filename" or die "Couldn't open $filename: $!";
    my $filesize = -s FILE;
    $chunk = $filesize if ($chunk >= $filesize);
    seek(FILE,-$chunk,2); # get last chunk of bytes

    my @tail = <FILE>;
    close FILE;
    if($numlines >= $#tail +1) {$numlines = $#tail + 1}
    splice @tail, 0, @tail - $numlines;

    print @tail;
}