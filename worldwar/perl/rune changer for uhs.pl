# Changes all players spawn and temple position (useful when changing map)
use warnings;

$runeid = 2273;
$count = 100;

for $file (glob ".../data/players/*")
{
	next unless $file =~ /\.xml$/;

	open(FILE, $file);
	@content = <FILE>;
	$_ = "@content";
	close(FILE);

	s/<item id="2274" count="100"\/>/<item id="$runeid" count="$count"\/>/;

	open(FILE, ">$file");
	print FILE;
	close(FILE);
}