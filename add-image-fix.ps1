# PowerShell script to add image fix to all product pages
$rootPath = "C:\xampp\htdocs\royscyberstore.com"
$shopPath = Join-Path $rootPath "shop"

Write-Host "Adding image fix script to all product pages..." -ForegroundColor Green

# Get all HTML files in shop subdirectories
$htmlFiles = Get-ChildItem -Path $shopPath -Recurse -Filter "*.html"

$updatedCount = 0
$totalCount = $htmlFiles.Count

foreach ($file in $htmlFiles) {
    try {
        $content = Get-Content $file.FullName -Raw
        
        # Check if fix-images.js is already included
        if ($content -notmatch "fix-images\.js") {
            # Calculate relative path from file to root
            $relativePath = ".."
            $depth = ($file.FullName.Split('\') | Where-Object { $_ -like "*LOGS*" -or $_ -like "*CARDS*" -or $_ -like "*TOOLS*" -or $_ -like "*WALLETS*" -or $_ -like "*SCRIPT*" }).Count
            if ($depth -gt 0) {
                $relativePath = "../.."
            }
            
            # Add the script before </html> or </body>
            if ($content -match "</html>") {
                $content = $content -replace "</html>", "<script src=`"$relativePath/fix-images.js`"></script>`r`n</html>"
            } elseif ($content -match "</body>") {
                $content = $content -replace "</body>", "<script src=`"$relativePath/fix-images.js`"></script>`r`n</body>"
            }
            
            # Write back to file
            Set-Content -Path $file.FullName -Value $content -NoNewline
            $updatedCount++
            Write-Host "Updated: $($file.Name)" -ForegroundColor Yellow
        } else {
            Write-Host "Skipped: $($file.Name) (already has fix-images.js)" -ForegroundColor Cyan
        }
    } catch {
        Write-Host "Error updating $($file.Name): $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`nImage fix script added to $updatedCount out of $totalCount product pages." -ForegroundColor Green
Write-Host "Note: The JavaScript will automatically fix broken images when pages load." -ForegroundColor Blue