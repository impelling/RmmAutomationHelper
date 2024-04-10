$Directories = @(Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue) + @(Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue)
foreach ($Import in @($Directories)) {
    try {
        . $Import.FullName
    } catch {
        Write-Error -Message "Failed to import function $($Import.FullName): $_"
    }
}
Export-ModuleMember -Function $Directories.BaseName -Alias *