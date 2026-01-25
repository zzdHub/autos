# 最小化环境检测
Write-Host "=== 环境信息 ==="
Write-Host "PowerShell: $($PSVersionTable.PSVersion) [$($PSVersionTable.PSEdition)]"
Write-Host "输出编码: $([Console]::OutputEncoding.EncodingName)"
Write-Host "输入编码: $([Console]::InputEncoding.EncodingName)"
Write-Host "代码页: $(chcp)"
Write-Host "中文测试: ✅ 你好世界"

# 你的原有脚本从这里开始
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
