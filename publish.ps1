Set-Location $PSScriptRoot

Write-Host "1. Testing Hexo build locally..." -ForegroundColor Cyan
npx hexo clean
npx hexo generate
if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed! Please fix the error above before pushing." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

$status = git status --porcelain
if (-not $status) {
    Write-Host "No changes detected. Nothing to push." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 0
}

$msg = Read-Host "Enter commit note (or press Enter for auto timestamp)"
if ([string]::IsNullOrWhiteSpace($msg)) {
    $msg = "update blog $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
}

Write-Host "2. Pushing to GitHub..." -ForegroundColor Cyan
git add .
git commit -m "$msg"
git push

if ($LASTEXITCODE -eq 0) {
    Write-Host "Done! Cloudflare Pages will update in ~1 minute." -ForegroundColor Green
} else {
    Write-Host "Push failed! Check the message above." -ForegroundColor Red
}

Read-Host "Press Enter to exit"