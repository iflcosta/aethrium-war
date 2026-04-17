# Changes all players spawn and temple position (useful when changing map)
use warnings;

$id = 2789;
$count = 100;

for $file (glob ".../data/players/*")
{
	next unless $file =~ /\.xml$/;

	open(FILE, $file);
	@content = <FILE>;
	$_ = "@content";
	close(FILE);

	s/<item id="2293" count="100" charges="\d+"\/>/<item id="$id" count="$count"\/>/;

	open(FILE, ">$file");
	print FILE;
	close(FILE);
}