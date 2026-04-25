$db = 'c:\aethrium-war\server\aethrium.db'
Add-Type -AssemblyName System.Data

# Use the SQLite .NET provider if available, otherwise parse manually
$bytes = [System.IO.File]::ReadAllBytes($db)
$ascii = [System.Text.Encoding]::ASCII.GetString($bytes)

# Find player names and context
$names = @('Bubble', 'guild_membership', 'guild_ranks', 'guilds')
foreach ($name in $names) {
    $idx = $ascii.IndexOf($name)
    if ($idx -ge 0) {
        Write-Host "Found '$name' at offset $idx"
        # Show surrounding context (readable chars only)
        $start = [Math]::Max(0, $idx - 50)
        $end = [Math]::Min($ascii.Length, $idx + 100)
        $ctx = $ascii.Substring($start, $end - $start) -replace '[^\x20-\x7E]', '.'
        Write-Host "  Context: $ctx"
    } else {
        Write-Host "'$name' NOT FOUND"
    }
}
