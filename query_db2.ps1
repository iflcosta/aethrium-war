$db = 'c:\aethrium-war\server\aethrium.db'
$bytes = [System.IO.File]::ReadAllBytes($db)
$ascii = [System.Text.Encoding]::ASCII.GetString($bytes)

# Find all player names near guild data - search for readable strings
# Look for guild names
$guildIdx = $ascii.IndexOf('CREATE TABLE `guilds`')
Write-Host "guilds table def at: $guildIdx"

# Find actual guild data by looking for INSERT patterns or data pages
# Search for known patterns - guilds table data
$patterns = @('Antica', 'Nova', 'Secura', 'Amera', 'Calmera', 'Hiberna', 'Harmonia')
foreach ($p in $patterns) {
    $idx = $ascii.IndexOf($p)
    if ($idx -ge 0) {
        $start = [Math]::Max(0, $idx - 30)
        $end = [Math]::Min($ascii.Length, $idx + 80)
        $ctx = $ascii.Substring($start, $end - $start) -replace '[^\x20-\x7E]', '.'
        Write-Host "Guild '$p': $ctx"
    }
}

# Look for Bubble's data more carefully
$bubbleIdx = $ascii.IndexOf('Bubble')
if ($bubbleIdx -ge 0) {
    $start = [Math]::Max(0, $bubbleIdx - 200)
    $end = [Math]::Min($ascii.Length, $bubbleIdx + 300)
    $raw = $bytes[$start..($end-1)]
    # Show hex around Bubble
    Write-Host "`nRaw bytes around Bubble (hex):"
    for ($i = 0; $i -lt $raw.Length; $i += 16) {
        $chunk = $raw[$i..([Math]::Min($i+15, $raw.Length-1))]
        $hex = ($chunk | ForEach-Object { '{0:X2}' -f $_ }) -join ' '
        $chr = ($chunk | ForEach-Object { if ($_ -ge 32 -and $_ -le 126) { [char]$_ } else { '.' } }) -join ''
        Write-Host ('{0:X6}: {1,-48} {2}' -f ($start+$i), $hex, $chr)
    }
}
