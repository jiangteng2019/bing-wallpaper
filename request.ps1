# 获取当前年份
$year = (Get-Date).Year

# 初始化项目文件夹
$docsPath = "./docs"
$docFilePath = "$docsPath/$year.md"
if (-not (Test-Path -Path $docsPath)) {
    New-Item -Path $docsPath -ItemType Directory
}
if (-not (Test-Path -Path $docFilePath)) {
    New-Item -Path $docFilePath -ItemType File
}

# 初始化日志文件夹
$logPath = "./log"
$logFilePath = "$logPath/$year.txt"
if (-not (Test-Path -Path $logPath)) {
    New-Item -Path $logPath -ItemType Directory
}
if (-not (Test-Path -Path $logFilePath)) {
    New-Item -Path $logFilePath -ItemType File
}

# 写日志文件
function Write-Log {
    param (
        [string]$Message
    )
    # 获取当前时间
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    # 构建完整的日志消息
    $logEntry = "${timestamp}: ${Message}"
    # 写入日志文件
    try {
        Add-Content -Path $LogFilePath -Value $logEntry
    } catch {
        Write-Error "无法写入日志文件: $_"
    }
}

# 请求URL
$url = "https://cn.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1"
try {
    $response = Invoke-WebRequest -Uri $url
    Write-Log -Message "请求url成功"
    # 解析JSON
    $json = $response.Content | ConvertFrom-Json
    $imageData = $json.images[0]
    $url = "https://cn.bing.com" + $imageData.url
    $title = $imageData.title
    $endDate = $imageData.enddate

    # 写入MD文件
    try {
        $mdContent = "* $endDate [$title]($url) "
        Add-Content -Path $docFilePath -Value $mdContent -Encoding UTF8
        Write-Log -Message "写入md成功"
    } catch {
        Write-Log -Message "写入md失败"
    }
} catch {
    Write-Log -Message "请求url失败"
}