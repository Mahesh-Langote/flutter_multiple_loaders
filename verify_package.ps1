# Verify the package before publishing

Write-Host "Flutter Multiple Loaders - Package Verification" -ForegroundColor Cyan
Write-Host "----------------------------------------------" -ForegroundColor Cyan

# Format all files
Write-Host "Formatting code..." -ForegroundColor Yellow
flutter format .

# Run static analysis
Write-Host "Running static analysis..." -ForegroundColor Yellow
flutter analyze
if ($LASTEXITCODE -ne 0) {
    Write-Host "Static analysis failed. Fix the issues and try again." -ForegroundColor Red
    exit 1
}

# Run tests
Write-Host "Running tests..." -ForegroundColor Yellow
flutter test
if ($LASTEXITCODE -ne 0) {
    Write-Host "Tests failed. Fix the issues and try again." -ForegroundColor Red
    exit 1
}

# Verify package can be published
Write-Host "Running dry-run publish to verify package..." -ForegroundColor Yellow
flutter pub publish --dry-run
if ($LASTEXITCODE -ne 0) {
    Write-Host "Package verification failed. Fix the issues and try again." -ForegroundColor Red
    exit 1
}

Write-Host "All checks passed! Package is ready for publishing." -ForegroundColor Green
Write-Host "Run 'flutter pub publish' to publish to pub.dev" -ForegroundColor Green
