# Fix Brand Consistency Script
Write-Host "Starting brand consistency fixes..." -ForegroundColor Green

$fixCount = 0
$allFiles = Get-ChildItem -Path "." -Recurse -Filter "*.html" | Where-Object { $_.Name -notlike "*report*" }

# Brand consistency mappings
$brandFixes = @{
    'LOGSHOP' = 'RoysCyberStore'
    'logshop.cc' = 'royscyberstore.com'
    'https://logshop.cc' = 'https://royscyberstore.com'
    'LogShop' = 'RoysCyberStore'
}

foreach ($file in $allFiles) {
    $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
    if ($content) {
        $originalContent = $content
        $fileFixed = $false
        
        # Apply brand fixes
        foreach ($oldBrand in $brandFixes.Keys) {
            $newBrand = $brandFixes[$oldBrand]
            if ($content.Contains($oldBrand)) {
                $content = $content.Replace($oldBrand, $newBrand)
                $fileFixed = $true
                Write-Host "  Fixed: $oldBrand -> $newBrand" -ForegroundColor Gray
            }
        }
        
        # Special case: Fix specific references that might have been missed
        if ($content.Contains('<span class="text-lg font-bold text-white ml-3">RoysCyberStore</span>') -and 
            $content.Contains('../../index.htm')) {
            # This is likely a shop page that still has wrong home link
            $content = $content.Replace('../../index.htm', '../../index.html')
            $fileFixed = $true
        }
        
        if ($fileFixed) {
            $content | Set-Content $file.FullName -Encoding UTF8
            Write-Host "Fixed branding in: $($file.Name)" -ForegroundColor Yellow
            $fixCount++
        }
    }
}

Write-Host "Fixed branding in $fixCount files" -ForegroundColor Green

# Also update the logo reference in index.html to point to the correct image
$indexFile = "index.html"
if (Test-Path $indexFile) {
    $content = Get-Content $indexFile -Raw
    if ($content.Contains('originals/2f/bf/ba/2fbfbacef953f5ff48b0c3fdb7ba5fe9-2.gif')) {
        $content = $content.Replace('originals/2f/bf/ba/2fbfbacef953f5ff48b0c3fdb7ba5fe9-2.gif', 'originals/2f/bf/ba/2fbfbacef953f5ff48b0c3fdb7ba5fe9.gif')
        $content | Set-Content $indexFile -Encoding UTF8
        Write-Host "Fixed logo reference in index.html" -ForegroundColor Green
    }
}

Write-Host "Brand consistency fixes completed!" -ForegroundColor Green