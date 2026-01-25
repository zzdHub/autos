# 在 script.ps1 的最开头添加
# 1. 如果 pwsh 存在，重新用 pwsh 执行当前脚本
if ($PSVersionTable.PSVersion.Major -lt 7) {
    if (Get-Command pwsh -ErrorAction SilentlyContinue) {
        Write-Host "检测到 Windows PowerShell，切换到 PowerShell 7..."
        pwsh -NoProfile -ExecutionPolicy Bypass -File $MyInvocation.MyCommand.Path @args
        exit $LASTEXITCODE
    }
}

# 2. 继续执行你的代码
Write-Host "=== 当前 PowerShell 版本 ==="
Write-Host "PowerShell: $($PSVersionTable.PSVersion) [$($PSVersionTable.PSEdition)]"
Write-Host "中文测试: ✅ 你好世界"

# ... 你的其他代码
