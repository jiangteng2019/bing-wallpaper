function Run-ScheduledTask {
    $scriptPath = Join-Path $PSScriptRoot "request.ps1"
    Invoke-Command -ScriptBlock { & $scriptPath }
}

# 设定每天执行的时间点
$targetHour = 9
$targetMinute = 0

while ($true) {
    $current = Get-Date
    $target = (Get-Date).Date.AddHours($targetHour).AddMinutes($targetMinute)

    # 检查当前时间是否接近目标时间
    if ($current -ge $target -and $current -lt $target.AddMinutes(1)) {
        Run-ScheduledTask
        Start-Sleep -Seconds 60 # 休眠一分钟，避免重复执行
    }
    else {
        # 计算下次检查的休眠时间，这里设置为约1分钟
        $sleepSeconds = [Math]::Max(0, 60 - ($current - $target).TotalSeconds % 60)
        Start-Sleep -Seconds $sleepSeconds
    }
}