# Website Link and Image Checker for royscyberstore.com
param(
    [string]$ReportPath = "link-and-image-report.html"
)

Write-Host "Starting comprehensive link and image check..." -ForegroundColor Green

$issues = @()
$workingDir = Get-Location

# Function to add issues
function Add-Issue {
    param($type, $file, $issue, $severity = "Warning")
    $issues += [PSCustomObject]@{
        Type = $type
        File = $file
        Issue = $issue
        Severity = $severity
    }
    Write-Host "[$severity] $type in $file`: $issue" -ForegroundColor $(if($severity -eq "Error") {"Red"} else {"Yellow"})
}

# Check if files exist
function Test-FileExists {
    param($path, $relativeTo = $workingDir)
    if ([System.IO.Path]::IsPathRooted($path)) {
        return Test-Path $path
    } else {
        $fullPath = Join-Path $relativeTo $path
        return Test-Path $fullPath
    }
}

# 1. Check main index.html navigation links
Write-Host "Checking main navigation links..." -ForegroundColor Cyan
$indexContent = Get-Content "index.html" -Raw

# Extract navigation links from index.html
$navLinks = @(
    "shop/USA%20BANK%20LOGS/CHASE%20BANK-2.html",
    "shop/USA%20BANK%20LOGS/HUNTINGTON%20BANK-2.html",
    "shop/USA%20BANK%20LOGS/BANK%20OF%20AMERICA-2.html",
    "shop/USA%20BANK%20LOGS/WELLS%20FARGO-2.html",
    "shop/USA%20BANK%20LOGS/CHIME%20BANK-2.html",
    "shop/USA%20BANK%20LOGS/CITIZENS%20BANK-2.html",
    "shop/USA%20BANK%20LOGS/PNC%20BANK-2.html",
    "shop/USA%20BANK%20LOGS/CREDIT%20UNIONS-2.html",
    "shop/MOBILE%20LOGS/CASHAPP%20%28Verified%29-2.html",
    "shop/MOBILE%20LOGS/PAYPAL-2.html",
    "shop/NON-USA%20BANK%20LOGS/Metro%20Bank%20UK-2.html",
    "shop/NON-USA%20BANK%20LOGS/Royal%20Bank-Scotland-2.html",
    "shop/NON-USA%20BANK%20LOGS/Banco%20Santander%20Spain-2.html",
    "shop/NON-USA%20BANK%20LOGS/Deutsche%20Bank-2.html",
    "shop/NON-USA%20BANK%20LOGS/Banque%20Populaire-2.html",
    "shop/NON-USA%20BANK%20LOGS/AMP%20Bank%20Australia-2.html",
    "shop/NON-USA%20BANK%20LOGS/TD-Toronto-2.html",
    "shop/NON-USA%20BANK%20LOGS/First%20Bank%20Of%20Nigeria-2.html",
    "shop/CRYPTO%20WALLETS/Blockchain%20Accounts-2.html",
    "shop/CRYPTO%20WALLETS/Coinbase%20Accounts-2.html",
    "shop/SHOPWITHSCRIPT/Shopwithscript-2.html",
    "shop/GIFT%20CARDS/Visa%20Virtual%20Account-2.html",
    "shop/GIFT%20CARDS/MasterCard%20gift%20card-2.html",
    "shop/GIFT%20CARDS/Netflix-2.html",
    "shop/GIFT%20CARDS/Amazon-2.html",
    "shop/GIFT%20CARDS/Walmart%20e-gifts-2.html",
    "shop/CREDIT%26DEBIT%20CARDS/Live%20CC-2.html",
    "shop/CREDIT%26DEBIT%20CARDS/Random%20CC%20with%20CVV-2.html",
    "shop/SECURE%20CASHOUT%20TOOLS/VPN%20Service-2.html",
    "shop/SECURE%20CASHOUT%20TOOLS/RDP-2.html",
    "shop/SECURE%20CASHOUT%20TOOLS/OTP%20bots-2.html"
)

foreach ($link in $navLinks) {
    $decodedLink = [System.Web.HttpUtility]::UrlDecode($link)
    if (-not (Test-FileExists $decodedLink)) {
        # Check if the file without -2 exists
        $alternativeLink = $decodedLink -replace "-2\.html$", ".html"
        if (Test-FileExists $alternativeLink) {
            Add-Issue "Broken Navigation Link" "index.html" "Link points to missing file '$decodedLink' but '$alternativeLink' exists" "Error"
        } else {
            Add-Issue "Broken Navigation Link" "index.html" "Link points to missing file '$decodedLink'" "Error"
        }
    }
}

# 2. Check product images referenced in shop pages
Write-Host "Checking product images in shop pages..." -ForegroundColor Cyan
$shopFiles = Get-ChildItem -Path "shop" -Recurse -Filter "*.html"

foreach ($shopFile in $shopFiles) {
    $content = Get-Content $shopFile.FullName -Raw -ErrorAction SilentlyContinue
    if ($content) {
        # Extract image src attributes
        $imageMatches = [regex]::Matches($content, 'src="([^"]*\.(?:jpg|jpeg|png|gif|webp))"', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        
        foreach ($match in $imageMatches) {
            $imagePath = $match.Groups[1].Value
            $relativePath = $shopFile.DirectoryName
            
            # Convert relative path to absolute
            if ($imagePath.StartsWith("../../")) {
                $imagePath = $imagePath.Substring(6)
                $fullImagePath = Join-Path $workingDir $imagePath
            } elseif ($imagePath.StartsWith("../")) {
                $imagePath = $imagePath.Substring(3)
                $fullImagePath = Join-Path (Split-Path $relativePath -Parent) $imagePath
            } else {
                $fullImagePath = Join-Path $relativePath $imagePath
            }
            
            if (-not (Test-Path $fullImagePath)) {
                Add-Issue "Missing Product Image" $shopFile.Name "Image not found: $imagePath" "Error"
            }
        }
    }
}

# 3. Check for orphaned product images
Write-Host "Checking for orphaned product images..." -ForegroundColor Cyan
$productImages = Get-ChildItem -Path "product" -Filter "*.*" -ErrorAction SilentlyContinue
$referencedImages = @()

# Collect all referenced images from shop files
foreach ($shopFile in $shopFiles) {
    $content = Get-Content $shopFile.FullName -Raw -ErrorAction SilentlyContinue
    if ($content) {
        $imageMatches = [regex]::Matches($content, 'src="[^"]*product/([^"]*)"')
        foreach ($match in $imageMatches) {
            $referencedImages += $match.Groups[1].Value
        }
    }
}

foreach ($image in $productImages) {
    if ($image.Name -notin $referencedImages) {
        Add-Issue "Orphaned Product Image" "product/" "Image '$($image.Name)' is not referenced by any product page" "Warning"
    }
}

# 4. Check internal navigation consistency within shop pages
Write-Host "Checking internal navigation consistency..." -ForegroundColor Cyan
foreach ($shopFile in $shopFiles) {
    $content = Get-Content $shopFile.FullName -Raw -ErrorAction SilentlyContinue
    if ($content) {
        # Check sidebar navigation links
        $sidebarLinks = [regex]::Matches($content, 'href="([^"]*\.html)"')
        foreach ($match in $sidebarLinks) {
            $link = $match.Groups[1].Value
            $linkDir = Split-Path $shopFile.DirectoryName
            
            if ($link.StartsWith("../")) {
                $targetPath = Join-Path $linkDir $link.Substring(3)
            } elseif ($link.StartsWith("../../")) {
                $targetPath = Join-Path (Split-Path $linkDir -Parent) $link.Substring(6)
            } else {
                $targetPath = Join-Path $shopFile.DirectoryName $link
            }
            
            $decodedPath = [System.Web.HttpUtility]::UrlDecode($targetPath)
            if (-not (Test-Path $decodedPath)) {
                Add-Issue "Broken Internal Link" $shopFile.Name "Link to '$link' not found" "Error"
            }
        }
    }
}

# 5. Check external links
Write-Host "Checking external links..." -ForegroundColor Cyan
$allHtmlFiles = Get-ChildItem -Path "." -Filter "*.html" -Recurse

foreach ($htmlFile in $allHtmlFiles) {
    $content = Get-Content $htmlFile.FullName -Raw -ErrorAction SilentlyContinue
    if ($content) {
        $externalLinks = [regex]::Matches($content, 'href="(https?://[^"]*)"')
        foreach ($match in $externalLinks) {
            $url = $match.Groups[1].Value
            try {
                $response = Invoke-WebRequest -Uri $url -Method Head -TimeoutSec 10 -ErrorAction Stop
                if ($response.StatusCode -ge 400) {
                    Add-Issue "External Link Issue" $htmlFile.Name "External link returns status $($response.StatusCode): $url" "Warning"
                }
            } catch {
                Add-Issue "External Link Issue" $htmlFile.Name "External link failed: $url - $($_.Exception.Message)" "Warning"
            }
        }
    }
}

# Generate HTML report
Write-Host "Generating report..." -ForegroundColor Cyan

$reportHtml = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RoysCyberStore Link and Image Check Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .error { color: red; background-color: #ffe6e6; padding: 5px; }
        .warning { color: orange; background-color: #fff5e6; padding: 5px; }
        .success { color: green; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        .summary { background-color: #f9f9f9; padding: 15px; margin-bottom: 20px; border-radius: 5px; }
    </style>
</head>
<body>
    <h1>RoysCyberStore - Link and Image Check Report</h1>
    <div class="summary">
        <h2>Summary</h2>
        <p><strong>Total Issues Found:</strong> $($issues.Count)</p>
        <p><strong>Errors:</strong> $(($issues | Where-Object {$_.Severity -eq "Error"}).Count)</p>
        <p><strong>Warnings:</strong> $(($issues | Where-Object {$_.Severity -eq "Warning"}).Count)</p>
        <p><strong>Report Generated:</strong> $(Get-Date)</p>
    </div>

    <h2>Issues Found</h2>
"@

if ($issues.Count -eq 0) {
    $reportHtml += "<p class='success'>No issues found! All links and images are working correctly.</p>"
} else {
    $reportHtml += "<table><tr><th>Severity</th><th>Type</th><th>File</th><th>Issue</th></tr>"
    foreach ($issue in $issues) {
        $class = if ($issue.Severity -eq "Error") { "error" } else { "warning" }
        $reportHtml += "<tr class='$class'><td>$($issue.Severity)</td><td>$($issue.Type)</td><td>$($issue.File)</td><td>$($issue.Issue)</td></tr>"
    }
    $reportHtml += "</table>"
}

$reportHtml += @"
    <h2>Recommendations</h2>
    <ul>
        <li><strong>Broken Navigation Links:</strong> Update index.html navigation to point to existing files (remove -2 suffix)</li>
        <li><strong>Missing Images:</strong> Ensure all referenced images exist in the product directory</li>
        <li><strong>Orphaned Images:</strong> Remove unused images to reduce storage space</li>
        <li><strong>External Links:</strong> Verify and update any broken external URLs</li>
    </ul>
</body>
</html>
"@

$reportHtml | Out-File -FilePath $ReportPath -Encoding UTF8

Write-Host "Report generated: $ReportPath" -ForegroundColor Green
Write-Host "Total issues found: $($issues.Count)" -ForegroundColor $(if($issues.Count -eq 0) {"Green"} else {"Red"})

# Return issues for further processing
return $issues