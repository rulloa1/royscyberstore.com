# Fix Internal Navigation Links Script
Write-Host "Starting internal navigation fixes..." -ForegroundColor Green

$fixCount = 0
$shopFiles = Get-ChildItem -Path "shop" -Recurse -Filter "*.html"

# Define the link mappings from broken to correct
$linkMappings = @{
    # USA Bank Logs - Remove -1 and -2 suffixes
    '../USA%20BANK%20LOGS/CHASE%20BANK-1.html' = '../USA%20BANK%20LOGS/CHASE%20BANK.html'
    '../USA%20BANK%20LOGS/CHASE%20BANK-2.html' = '../USA%20BANK%20LOGS/CHASE%20BANK.html'
    '../USA%20BANK%20LOGS/HUNTINGTON%20BANK-1.html' = '../USA%20BANK%20LOGS/HUNTINGTON%20BANK.html'
    '../USA%20BANK%20LOGS/HUNTINGTON%20BANK-2.html' = '../USA%20BANK%20LOGS/HUNTINGTON%20BANK.html'
    '../USA%20BANK%20LOGS/BANK%20OF%20AMERICA-1.html' = '../USA%20BANK%20LOGS/BANK%20OF%20AMERICA.html'
    '../USA%20BANK%20LOGS/BANK%20OF%20AMERICA-2.html' = '../USA%20BANK%20LOGS/BANK%20OF%20AMERICA.html'
    '../USA%20BANK%20LOGS/WELLS%20FARGO-1.html' = '../USA%20BANK%20LOGS/WELLS%20FARGO.html'
    '../USA%20BANK%20LOGS/WELLS%20FARGO-2.html' = '../USA%20BANK%20LOGS/WELLS%20FARGO.html'
    '../USA%20BANK%20LOGS/CHIME%20BANK-1.html' = '../USA%20BANK%20LOGS/CHIME%20BANK.html'
    '../USA%20BANK%20LOGS/CHIME%20BANK-2.html' = '../USA%20BANK%20LOGS/CHIME%20BANK.html'
    '../USA%20BANK%20LOGS/CITIZENS%20BANK-1.html' = '../USA%20BANK%20LOGS/CITIZENS%20BANK.html'
    '../USA%20BANK%20LOGS/CITIZENS%20BANK-2.html' = '../USA%20BANK%20LOGS/CITIZENS%20BANK.html'
    '../USA%20BANK%20LOGS/PNC%20BANK-1.html' = '../USA%20BANK%20LOGS/PNC%20BANK.html'
    '../USA%20BANK%20LOGS/PNC%20BANK-2.html' = '../USA%20BANK%20LOGS/PNC%20BANK.html'
    '../USA%20BANK%20LOGS/CREDIT%20UNIONS-1.html' = '../USA%20BANK%20LOGS/CREDIT%20UNIONS.html'
    '../USA%20BANK%20LOGS/CREDIT%20UNIONS-2.html' = '../USA%20BANK%20LOGS/CREDIT%20UNIONS.html'
    
    # Crypto Wallets
    '../CRYPTO%20WALLETS/Blockchain%20Accounts-1.html' = '../CRYPTO%20WALLETS/Blockchain%20Accounts.html'
    '../CRYPTO%20WALLETS/Blockchain%20Accounts-2.html' = '../CRYPTO%20WALLETS/Blockchain%20Accounts.html'
    '../CRYPTO%20WALLETS/Coinbase%20Accounts-1.html' = '../CRYPTO%20WALLETS/Coinbase%20Accounts.html'
    '../CRYPTO%20WALLETS/Coinbase%20Accounts-2.html' = '../CRYPTO%20WALLETS/Coinbase%20Accounts.html'
    
    # Other navigation links
    '../../show_order-1.html' = '../../show_order.html'
    '../../show_order-2.html' = '../../show_order.html'
    '../../orders-1.html' = '../../orders.html'
    '../../orders-2.html' = '../../orders.html'
}

foreach ($file in $shopFiles) {
    $content = Get-Content $file.FullName -Raw
    $originalContent = $content
    $fileFixed = $false
    
    # Apply all the link mappings
    foreach ($badLink in $linkMappings.Keys) {
        $goodLink = $linkMappings[$badLink]
        if ($content.Contains($badLink)) {
            $content = $content.Replace($badLink, $goodLink)
            $fileFixed = $true
            Write-Host "  Fixed: $badLink -> $goodLink" -ForegroundColor Gray
        }
    }
    
    # Also fix any remaining -1 or -2 references with a regex approach
    $regexPattern = 'href="([^"]*?)(-[12])\.html"'
    if ($content -match $regexPattern) {
        $content = $content -replace $regexPattern, 'href="$1.html"'
        $fileFixed = $true
    }
    
    if ($fileFixed) {
        $content | Set-Content $file.FullName -Encoding UTF8
        Write-Host "Fixed navigation in: $($file.Name)" -ForegroundColor Yellow
        $fixCount++
    }
}

Write-Host "Fixed internal navigation in $fixCount files" -ForegroundColor Green