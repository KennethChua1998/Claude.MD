# Links ~/.claude to this repo. Idempotent; re-run after adding a skill.
# Needs Developer Mode or an elevated shell for symlink creation.
$ErrorActionPreference = "Stop"
$repo = Split-Path $PSScriptRoot -Parent

function Link($path, $target) {
    $existing = Get-Item $path -ErrorAction SilentlyContinue
    if ($existing -and -not $existing.LinkType) {
        Copy-Item $existing.FullName "$($existing.FullName).bak"
        Write-Output "backed up: $path -> $path.bak"
    }
    if ($existing) { $existing.Delete() }
    New-Item -ItemType SymbolicLink -Path $path -Target $target | Out-Null
    Write-Output "linked: $path -> $target"
}

New-Item -ItemType Directory -Force "$HOME\.claude\skills" | Out-Null
Link "$HOME\.claude\CLAUDE.md" "$repo\global-CLAUDE.md"
Get-ChildItem "$repo\claude-skills" -Directory | ForEach-Object {
    Link "$HOME\.claude\skills\$($_.Name)" $_.FullName
}
