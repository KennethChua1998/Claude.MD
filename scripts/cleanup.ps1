# Removes the ~/.claude symlinks created by setup.ps1 and unmodified local copies of them.
# Modified copies and links into other repos are kept.
$ErrorActionPreference = "Stop"
$repo = Split-Path $PSScriptRoot -Parent

function SameContent($a, $b) {
    if ((Get-Item $a) -is [IO.DirectoryInfo]) {
        $fa = Get-ChildItem $a -Recurse -File | ForEach-Object { $_.FullName.Substring($a.Length) }
        $fb = Get-ChildItem $b -Recurse -File | ForEach-Object { $_.FullName.Substring($b.Length) }
        if (Compare-Object $fa $fb) { return $false }
        foreach ($rel in $fa) {
            if ((Get-FileHash "$a$rel").Hash -ne (Get-FileHash "$b$rel").Hash) { return $false }
        }
        return $true
    }
    (Get-FileHash $a).Hash -eq (Get-FileHash $b).Hash
}

function Unlink($path, $source) {
    $existing = Get-Item $path -ErrorAction SilentlyContinue
    if (-not $existing) { return }
    if (-not $existing.LinkType) {
        if (SameContent $existing.FullName $source) {
            Remove-Item $existing.FullName -Recurse -Force
            Write-Output "removed copy: $path"
        } else {
            Write-Output "kept (differs from repo): $path"
        }
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

Unlink "$HOME\.claude\CLAUDE.md" "$repo\global-CLAUDE.md"
Get-ChildItem "$repo\claude-skills" -Directory | ForEach-Object {
    Unlink "$HOME\.claude\skills\$($_.Name)" $_.FullName
}

if ((Test-Path "$HOME\.claude\CLAUDE.md.bak") -and -not (Test-Path "$HOME\.claude\CLAUDE.md")) {
    Move-Item "$HOME\.claude\CLAUDE.md.bak" "$HOME\.claude\CLAUDE.md"
    Write-Output "restored: $HOME\.claude\CLAUDE.md (from .bak)"
}
