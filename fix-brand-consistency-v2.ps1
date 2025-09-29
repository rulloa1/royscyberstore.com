# Fix Brand Consistency Script
Write-Host "Starting brand consistency fixes..." -ForegroundColor Green

$fixCount = 0
$allFiles = Get-ChildItem -Path "." -Recurse -Filter "*.html" | Where-Object { $_.Name -notlike "*report*" }

foreach ($file in $allFiles) {
    $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
    if ($content) {
        $originalContent = $content
        $fileFixed = $false
        
        # Apply brand fixes one by one to avoid conflicts
        if ($content.Contains('LOGSHOP')) {
            $content = $content.Replace('LOGSHOP', 'RoysCyberStore')
            $fileFixed = $true
            Write-Host "  Fixed: LOGSHOP -> RoysCyberStore" -ForegroundColor Gray
        }
        
        if ($content.Contains('https://logshop.cc')) {
            $content = $content.Replace('https://logshop.cc', 'https://royscyberstore.com')
            $fileFixed = $true
            Write-Host "  Fixed: https://logshop.cc -> https://royscyberstore.com" -ForegroundColor Gray
        }
        
        if ($content.Contains('logshop.cc')) {
            $content = $content.Replace('logshop.cc', 'royscyberstore.com')
            $fileFixed = $true
            Write-Host "  Fixed: logshop.cc -> royscyberstore.com" -ForegroundColor Gray
        }
        
        # Fix index references  
        if ($content.Contains('../../index.htm"')) {
            $content = $content.Replace('../../index.htm', '../../index.html')
            $fileFixed = $true
            Write-Host "  Fixed: index.htm -> index.html" -ForegroundColor Gray
        }
        
        if ($content.Contains('index-2.htm')) {
            $content = $content.Replace('index-2.htm', 'index.html')
            $fileFixed = $true
            Write-Host "  Fixed: index-2.htm -> index.html" -ForegroundColor Gray
        }
        
        if ($fileFixed) {
            $content | Set-Content $file.FullName -Encoding UTF8
            Write-Host "Fixed branding in: $($file.Name)" -ForegroundColor Yellow
            $fixCount++
        }
    }
}

Write-Host "Fixed branding in $fixCount files" -ForegroundColor Green

# Fix logo reference if it exists
$indexFile = "index.html"
if (Test-Path $indexFile) {
    $content = Get-Content $indexFile -Raw
    $originalContent = $content
    
    if ($content.Contains('2fbfbacef953f5ff48b0c3fdb7ba5fe9-2.gif')) {
        $content = $content.Replace('2fbfbacef953f5ff48b0c3fdb7ba5fe9-2.gif', '2fbfbacef953f5ff48b0c3fdb7ba5fe9.gif')
        Write-Host "Fixed logo reference in index.html" -ForegroundColor Green
    }
    
    if ($content -ne $originalContent) {
        $content | Set-Content $indexFile -Encoding UTF8
    }
}

Write-Host "Brand consistency fixes completed!" -ForegroundColor Green