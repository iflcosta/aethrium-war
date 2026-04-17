# Changes all players spawn and temple position (useful when changing map)
use warnings;

$id = 2268;
$count = 100;

for $file (glob ".../data/players/*")
{
	next unless $file =~ /\.xml$/;

	open(FILE, $file);
	@content = <FILE>;
	$_ = "@content";
	close(FILE);

	s/<item id="2263" count="100"\/>/<item id="$id" count="$count"\/>/;

	open(FILE, ">$file");
	print FILE;
	close(FILE);
}