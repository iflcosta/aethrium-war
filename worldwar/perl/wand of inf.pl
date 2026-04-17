# Changes all players spawn and temple position (useful when changing map)
use warnings;

$id = 2187;

for $file (glob ".../data/players3/*")
{
	next unless $file =~ /\.xml$/;

	open(FILE, $file);
	@content = <FILE>;
	$_ = "@content";
	close(FILE);

	s/<item id="2436"\/>/<item id="$id"\/>/;

	open(FILE, ">$file");
	print FILE;
	close(FILE);
}