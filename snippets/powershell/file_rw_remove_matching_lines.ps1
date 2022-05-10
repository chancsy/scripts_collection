# Remove lines with matching search string

# Prepare test
Set-Content -Path "test.txt" "Line 1"
Add-Content -Path "test.txt" "Line 2"
Add-Content -Path "test.txt" "Line 3 remove this line"
Add-Content -Path "test.txt" "Line 4"
Add-Content -Path "test.txt" "Line 5"

# Show Before
Write-Host "Before:"
get-content -Path "test.txt"

# Actual Script
$Filename = "test.txt"
$SearchString = "remove"
# Version 1
# (get-content $Filename | Select-String -Pattern $SearchString -NotMatch) | Set-Content $Filename
# Version 2
Remove-Lines -Filename "test.txt" -SearchString "remove"

# Show After
Write-Host "`nAfter:"
get-content -Path "test.txt"

# Finish test
Remove-Item "test.txt"