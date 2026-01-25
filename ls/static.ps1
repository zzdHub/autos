# 安卓主模板配置文件
$mainConfigPath = "D:\Software\VPN\Convert\sub2sing-box_0.0.9_windows_amd64\mainConfig.json"
# 该文件是脚本第一次从机场拉取到的数据，未经任何处理的配置
$subConfigPath = "D:\Software\VPN\Convert\sub2sing-box_0.0.9_windows_amd64\UnFormattedConfig.json"
$outputPath = "D:\Software\VPN\Convert\sub2sing-box_0.0.9_windows_amd64\merge.json"
# 最终输出文件为merged_formatted.json 

# ====== SCP 上传文件配置 ======
$sshKeyPath = "C:/Users/admin/.ssh/singbox_key"
$localConfigPath = "D:/Software/VPN/Convert/sub2sing-box_0.0.9_windows_amd64/merged_formatted.json"
$sshUser = "u0_a279"
$phoneIP = "192.168.0.101"
$sshPort = 8022
$remotePath = "storage/downloads/singbox/merged_formatted.json"
$logFile = "D:\Software\VPN\Convert\sub2sing-box_0.0.9_windows_amd64\AutoUpdateLog\log.txt" # 日志文件路径
# 模板文件路径
$template = "D:\Software\VPN\Convert\sub2sing-box_0.0.9_windows_amd64\templates.json"
# 输出总配置文件
$UnConfig = "UnFormattedConfig.json"



# sshd 连通性测试标识
$success = $false