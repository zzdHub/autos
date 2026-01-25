
# 在当前目录执行这个命令，它会修复编码问题
$content = Get-Content "hhh.ps1" -Raw
[System.IO.File]::WriteAllText("hhh.ps1", $content, [System.Text.Encoding]::UTF8)

$jsonPath = "D:\a\autos\autos\ls\UnFormattedConfig.json"

if (!(Test-Path $jsonPath)) {
    Write-Error "找不到文件 $jsonPath"
    exit 1
}

$fileInfo = Get-Item $jsonPath
$sizeMB = [Math]::Round($fileInfo.Length / 1MB, 2)

Write-Host "JSON 文件存在"
Write-Host "文件大小: $sizeMB MB"


Write-Host "its ok"

