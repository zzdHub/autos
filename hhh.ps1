# 要写入的内容（模拟“生成的数据”）
$data = @{
    status = 'ok'
    message = 'excute ok'
    time = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
}

# 转成 JSON
$json = $data | ConvertTo-Json -Depth 3

# 输出目录（当前仓库根目录）
$file = "D:\a\autos\autos\1.json"

# 写入文件（不存在会创建，存在会覆盖）
$json | Set-Content -Path $file -Encoding UTF8

Write-Host "its ok: $file"

