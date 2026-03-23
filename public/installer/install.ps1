# ============================================================
# SpectrumWatch â€” One-Click Installer
# Run as: powershell -ExecutionPolicy Bypass -File install.ps1
# ============================================================

$AppName    = "SpectrumWatch"
$AppVersion = "1.0.0"
$RepoUrl    = "https://github.com/brianallicat/spectrumwatch"
$AppUrl     = "https://spectrumwatch.netlify.app"

function Write-Cyan($msg)   { Write-Host $msg -ForegroundColor Cyan }
function Write-Green($msg)  { Write-Host $msg -ForegroundColor Green }
function Write-Yellow($msg) { Write-Host $msg -ForegroundColor Yellow }

Clear-Host
Write-Cyan "SPECTRUMWATCH - Installer"
Write-Yellow "Installing..."

$DesktopPath = [Environment]::GetFolderPath("Desktop")
$AppDataPath = "$env:APPDATAUÐectrumWatch"
$IconPath = "$AppDataPath\spectrumwatch.ico"
$ShortcutPath = "$DesktopPath\SpectrumWatch.lnk"

New-Item -ItemType Directory -Path $AppDataPath -Force | Out-Null

Add-Type -AssemblyName System.Drawing
$bmp = New-Object System.Drawing.Bitmap(256,256)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.Clear([System.Drawing.Color]::FromArgb(255,4,8,16))
$cyan = [System.Drawing.Color]::FromArgb(255,0,212,255)
$g.DrawEllipse((New-Object System.Drawing.Pen($cyan,6)),16,16,224,224)
$g.DrawEllipse((New-Object System.Drawing.Pen($cyan,4)),58,58,140,140)
$g.DrawEllipse((New-Object System.Drawing.Pen($cyan,3)),98,98,60,60)
$g.FillEllipse((New-Object System.Drawing.SolidBrush($cyan)),116,116,24,24)
$g.DrawLine((New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(200,0,212,255),3)),128,128,215,41)
$g.Dispose()
$ms = New-Object System.IO.MemoryStream
$bmp.Save($ms,[System.Drawing.Imaging.ImageFormat]::Png)
$png = $ms.ToArray()
$bmp.Dispose()
$fs = New-Object System.IO.FileStream($IconPath,[System.IO.FileMode]::Create)
$bw = New-Object System.IO.BinaryWriter($fs)
$bw.Write([uint16]0);$bw.Write([uint16]1);$bw.Write([uint16]1)
$bw.Write([byte]0);$bw.Write([byte]0);$bw.Write([byte]0);$bw.Write([byte]0)
$bw.Write([uint16]1);$bw.Write([uint16]32)
$bw.Write([uint32]$png.Length);$bw.Write([uint32]22)
$bw.Write($png);$bw.Close();$fs.Close()

$shell = New-Object -ComObject WScript.Shell
$sc = $shell.CreateShortcut("$DesktopPath\SpectrumWatch.lnk")
if (Test-Path "C:\Program Files\Google\Chrome\Application\chrome.exe") {
  $sc.TargetPath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
  $sc.Arguments = "--app=$AppUrl --window-size=1440,900"
} elseif (Test-Path "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe") {
  $sc.TargetPath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
  $sc.Arguments = "--app=$AppUrl --window-size=1440,900"
} else {
  $sc.TargetPath = "explorer.exe"
  $sc.Arguments = $AppUrl
}
$sc.IconLocation = "$IconPath,0"
$sc.Description = "SpectrumWatch Live RF Intelligence"
$sc.Save()

Write-Green "Desktop icon created!"

if (Test-Path "C:\Program Files\Google\Chrome\Application\chrome.exe") {
  Start-Process "C:\Program Files\Google\Chrome\Application\chrome.exe" "--app=$AppUrl --window-size=1440,900"
} elseif (Test-Path "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe") {
  Start-Process "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" "--app=$AppUrl --window-size=1440,900"
} else {
  Start-Process $AppUrl
}

Write-Green "SpectrumWatch launched!"
Write-Cyan "Live at: https://spectrumwatch.netlify.app"
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
