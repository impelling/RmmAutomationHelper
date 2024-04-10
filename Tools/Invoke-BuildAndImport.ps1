$RequireModule = 'ModuleBuilder'

if (-not (Get-Module -Name $RequireModule -ListAvailable)) {
    Install-Module -Name $RequireModule -Scope CurrentUser -Force
}

if (-not (Get-Module -Name $RequireModule)) {
    Import-Module -Name $RequireModule
}

Build-Module -VersionedOutputDirectory:$false -Verbose

$ModuleName = Get-ChildItem -Path .\Output -Directory | Select-Object -First 1 -ExpandProperty Name

Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
Import-Module .\Output\$ModuleName\$ModuleName.psm1 -Verbose