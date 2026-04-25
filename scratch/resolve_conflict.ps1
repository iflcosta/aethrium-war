$path = 'c:\aethrium-war\client\src\CMakeLists.txt'
$content = Get-Content $path
# Keep up to line 354 (index 353), then lines 372-374 (index 371-373), then from line 376 (index 375)
$newContent = $content[0..353] + $content[371..373] + $content[375..($content.Length-1)]
$newContent | Set-Content $path -Encoding UTF8
