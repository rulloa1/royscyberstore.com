# Fix Product Image References Script
Write-Host "Starting image reference fixes..." -ForegroundColor Green

$fixCount = 0
$shopFiles = Get-ChildItem -Path "shop" -Recurse -Filter "*.html"

foreach ($file in $shopFiles) {
    $content = Get-Content $file.FullName -Raw
    $originalContent = $content
    
    # Fix image references that include -1 or -2 suffixes
    # Pattern: src="../../product/filename-1.ext" or src="../../product/filename-2.ext"
    $content = $content -replace 'src="(\.\./\.\./product/[^"]*?)(-[12])\.(jpg|jpeg|png|gif|webp)"', 'src="$1.$3"'
    
    # Pattern: src="product/filename-1.ext" or src="product/filename-2.ext"  
    $content = $content -replace 'src="(product/[^"]*?)(-[12])\.(jpg|jpeg|png|gif|webp)"', 'src="$1.$3"'
    
    if ($content -ne $originalContent) {
        $content | Set-Content $file.FullName -Encoding UTF8
        Write-Host "Fixed images in: $($file.Name)" -ForegroundColor Yellow
        $fixCount++
    }
}

Write-Host "Fixed $fixCount files with image reference issues" -ForegroundColor Green

# Now fix any remaining issues by checking for specific missing images and updating them
$specificFixes = @{
    "1728634123-1.jpg" = "1728634123.jpg"
    "1728634123-2.jpg" = "1728634123.jpg"
    "1728641005-1.jpg" = "1728641005.jpg"
    "1728641005-2.jpg" = "1728641005.jpg"
    "1728641129-1.jpg" = "1728641129.jpg"
    "1728641129-2.jpg" = "1728641129.jpg"
}

foreach ($file in $shopFiles) {
    $content = Get-Content $file.FullName -Raw
    $originalContent = $content
    
    foreach ($badImage in $specificFixes.Keys) {
        $goodImage = $specificFixes[$badImage]
        if ($content.Contains($badImage)) {
            $content = $content.Replace($badImage, $goodImage)
            Write-Host "Specifically fixed: $badImage -> $goodImage in $($file.Name)" -ForegroundColor Cyan
        }
    }
    
    if ($content -ne $originalContent) {
        $content | Set-Content $file.FullName -Encoding UTF8
    }
}

Write-Host "Image reference fixes completed!" -ForegroundColor Green