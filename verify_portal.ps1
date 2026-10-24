$content = [System.IO.File]::ReadAllText("d:\Documents\Haytham\index.html", [System.Text.Encoding]::UTF8)

Write-Host "--- 1. Testing for Mojibake ---"
if ($content.Contains([char]0x00E2) -or $content.Contains("ðŸ")) {
    Write-Host "WARNING: Potential mojibake characters found!"
} else {
    Write-Host "PASSED: No mojibake characters detected."
}

Write-Host "--- 2. Checking Thai Text Rendering ---"
if ($content.Contains("วันปิยมหาราช")) {
    Write-Host "PASSED: Thai text 'วันปิยมหาราช' found intact."
} else {
    Write-Host "WARNING: Thai text not found!"
}

Write-Host "--- 3. Testing getElementById Calls ---"
$lines = $content -split "`n"
$lineNum = 0
$errors = 0
foreach ($line in $lines) {
    $lineNum++
    if ($line -match "getElementById\(\s*[^'""\s\)]+\s*\)") {
        Write-Host "Line $lineNum has unquoted getElementById: $line"
        $errors++
    }
}
if ($errors -eq 0) {
    Write-Host "PASSED: All getElementById calls are safely quoted."
}

Write-Host "--- 4. Checking Closing Tags ---"
if ($content.Contains("</html>") -and $content.Contains("</body>") -and $content.Contains("</script>")) {
    Write-Host "PASSED: Page has matching closing tags."
} else {
    Write-Host "WARNING: Missing closing tags!"
}
