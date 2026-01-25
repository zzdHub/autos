# 设置控制台和输出编码为 UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 > $null
# Load static resources...
. "D:\Software\VPN\Convert\sub2sing-box_0.0.9_windows_amd64\static.ps1"
. "D:\Software\VPN\Convert\sub2sing-box_0.0.9_windows_amd64\AreesSubs.ps1"
$successSubs = @() 
# 循环测试
for ($i = 0; $i -lt $subs.Count; $i++) {
    Write-Host "test subs: $($i+1): $($subs[$i])" 
    # 执行 sub2sing-box.exe，捕获所有输出
    $output = & .\sub2sing-box.exe convert -s $subs[$i]
    $exitCode = $LASTEXITCODE
    if ($exitCode -ne 0 -or $output -match "(?i)error|forbidden|invalid") {
        Write-Host "sub $($i+1) error" 
    }
    else {
        Write-Host "sub $($i+1) successful" 
        $successSubs += $subs[$i]
    }
}
# 构造参数数组  -d 参数靠tag 删除节点
Write-Host "build script parameters....."
$params = @("-t", $template, "-o", $UnConfig, "-G", "urltest")
$successSubs | ForEach-Object {
    $params += "-s"
    $params += $_
}
Write-Host "excute the powersheel script......"
& .\sub2sing-box.exe convert @params
try {
    # 读取 JSON 内容
    Write-Host "get the configuration file templates ...."
    $mainJsonRaw = [System.IO.File]::ReadAllText($mainConfigPath, [System.Text.Encoding]::UTF8)
    $subJsonRaw = [System.IO.File]::ReadAllText($subConfigPath, [System.Text.Encoding]::UTF8)
}
catch {
    Write-Host "failed to read the configuration file: $($_.Exception.Message)"
}
try {
    # 转换为 JSON 对象
    $mainJson = $mainJsonRaw | ConvertFrom-Json -ErrorAction Stop
    $subJson = $subJsonRaw | ConvertFrom-Json -ErrorAction Stop
}
catch {
    Write-Host "failed to parse the file. please check try agin : $($_.Exception.Message)"
}
$deRegex = '(?i)hysteria2|vmess'
# 根据type和tag 筛选需要删除的tag 
$deleteTags = $subJson.outbounds | 
Where-Object { 
    # $_.type -match $deRegex -or
    if ( $_.type -match $deRegex -or $_.tag -match '(?i)过滤|建议') { return $_ }
} | Select-Object -ExpandProperty tag


# ====== 删除外层的不符合节点 ======
$subJson.outbounds = $subJson.outbounds | Where-Object {
    $_.tag -notin $deleteTags 
}

# 删除urltest, select 中的不符合节点 
foreach ($o in $subJson.outbounds) {
    if ($o.outbounds) {
        $o.outbounds = @($o.outbounds | Where-Object {
                $_ -notin $deleteTags 
            })
    }
}

# 清理节点特别少的节点
$deletenull = foreach ($o in $subJson.outbounds) {
    if ($o.type -in ("urltest")) {
        # 再次清理urltest 数组小于4 的 踢出去
        if ($o.outbounds.Count -ge 0 -and $o.outbounds.Count -lt 4) {            
            $o.tag
        }       
    }    
}
#清理urltest
$subJson.outbounds = $subJson.outbounds | Where-Object { $_.tag -notin $deletenull } 
# 清理select
foreach ($o in $subJson.outbounds) {
    if ($o.type -in ("selector") ) {
        if ($o.outbounds) {
            $o.outbounds = @($o.outbounds | Where-Object {
                    $_ -notin $deletenull
                })
        }   
    }
}
$mainJson.outbounds = $subJson.outbounds 
foreach ($out in $mainJson.outbounds) {
    if ($out.type -eq "urltest") {
        if (-not $out.PSObject.Properties["interval"]) {
            $out | Add-Member -NotePropertyName "interval" -NotePropertyValue "10m"
        }
    }
}
$mainJson | ConvertTo-Json -Depth 100 | Out-File .\merged_formatted.json -Encoding utf8
do {
    # upload 先测试是否连通
    ssh -i "$sshKeyPath" -p 8022 user@192.168.0.101 exit
    if ($LASTEXITCODE -ne 0) {
        Start-Sleep -Seconds 4
        Write-Host "wait for reconnection......"
        continue
    }
    scp -i "$sshKeyPath" -P "$sshPort" "$localConfigPath" "${sshUser}@${phoneIP}:$remotePath"
    if ($LASTEXITCODE -eq 0) {
        Write-Host "The configuration upload was successful."
        $success = $true
    }
    else {
        Write-Host "An error occurred during the upload process.：$($_)"
    }
}while (-not $success)

