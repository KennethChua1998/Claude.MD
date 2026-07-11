# Removes the ~/.claude symlinks created by setup.ps1. Leaves anything this repo does not own.
$ErrorActionPreference = "Stop"
$repo = Split-Path $PSScriptRoot -Parent

function Unlink($path) {
    $existing = Get-Item $path -ErrorAction SilentlyContinue
    if (-not $existing) { return }
    if (-not $existing.LinkType) {
        Write-Output "kept (not a symlink): $path"
        return
    }
    $target = if ($existing.LinkTarget) { $existing.LinkTarget } else { @($existing.Target)[0] }
    if (-not ($target -like "$repo*")) {
        Write-Output "kept (links elsewhere): $path -> $target"
        return
    }
    $existing.Delete()
    Write-Output "unlinked: $path"
}

Unlink "$HOME\.claude\CLAUDE.md"
Get-ChildItem "$repo\claude-skills" -Directory | ForEach-Object {
    Unlink "$HOME\.claude\skills\$($_.Name)"
}

if ((Test-Path "$HOME\.claude\CLAUDE.md.bak") -and -not (Test-Path "$HOME\.claude\CLAUDE.md")) {
    Move-Item "$HOME\.claude\CLAUDE.md.bak" "$HOME\.claude\CLAUDE.md"
    Write-Output "restored: $HOME\.claude\CLAUDE.md (from .bak)"
}
