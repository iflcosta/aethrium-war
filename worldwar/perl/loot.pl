# Generates list of monsters with their loot
use warnings;

open(FILE, "../data/items/items.xml");

while (<FILE>)
{
	if (/<item id="(\d+)" name="(.*?)"/)
	{
		$items[$1] = $2;
	}
}

close(FILE);
open(OUT, ">loot.txt");

for $file (glob "../data/monster/*")
{
	next unless $file =~ /xml$/;
	$file =~ /.*\/(.*)\.xml/;
	print OUT "\n$1\n";

	open(FILE, $file);

	while ($_ = <FILE>)
	{
		if (/<item id="(.*?)"/)
		{
			if (defined($items[$1])) {
				print OUT "\t$1 $items[$1]"; }
			else {
				print OUT "\t$1"; }

			if (/chance="(.*?)"/) {
				print OUT "\t(chance=$1)"; }
			if (/countmax="(.*?)" chance1="(.*?)"/) {
				print OUT "\t(countmax=$1 chance1=$2)"; }

			print OUT "\n";
		}
	}

	close(FILE);
}

close(OUT);