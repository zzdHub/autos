

# 输出目录（当前仓库根目录）
$file = "D:\a\autos\autos\ls\UnFormattedConfig.json"

# 写入文件（不存在会创建，存在会覆盖）
$json | Set-Content -Path $file -Encoding UTF8

Write-Host "its ok: $file"

