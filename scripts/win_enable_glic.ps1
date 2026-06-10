# Windows PowerShell Script to enable Google Chrome AI features (GLIC)
# Project: enable-chrome-glic-in-cn
# GitHub: https://github.com/your-username/enable_chrome_glic_in_cn

$ErrorActionPreference = "Stop"

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "         正在启用 Google Chrome AI (GLIC)        " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

$localStatePath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Local State"

# 1. 检查 Local State 是否存在
if (-not (Test-Path $localStatePath)) {
    Write-Host "[错误] 找不到 Chrome Local State 配置文件。" -ForegroundColor Red
    Write-Host "请确认此电脑上已安装 Google Chrome 浏览器。" -ForegroundColor Red
    Write-Host ""
    Read-Host "按回车键退出..."
    exit
}

# 2. 关闭 Chrome 进程
Write-Host "[1/5] 正在关闭所有 Chrome 浏览器进程..." -ForegroundColor Yellow
$chromeProcesses = Get-Process -Name chrome -ErrorAction SilentlyContinue
if ($chromeProcesses) {
    Stop-Process -Name chrome -Force
    Start-Sleep -Seconds 2
    Write-Host "[SUCCESS] 已成功关闭 Chrome 浏览器进程。" -ForegroundColor Green
} else {
    Write-Host "[INFO] 未检测到正在运行的 Chrome 浏览器。" -ForegroundColor Gray
}

# 3. 创建备份
$timestamp = Get-Date -Format "yyyyMMddHHmmss"
$backupPath = "$localStatePath.backup.$timestamp"
try {
    Copy-Item -Path $localStatePath -Destination $backupPath -Force
    Write-Host "[2/5] 已成功创建原配置文件的备份：" -ForegroundColor Green
    Write-Host "      $backupPath" -ForegroundColor Gray
} catch {
    Write-Host "[错误] 备份配置文件失败：$_" -ForegroundColor Red
    Read-Host "按回车键退出..."
    exit
}

# 4. 修改 JSON
Write-Host "[3/5] 正在读取并修改配置文件..." -ForegroundColor Yellow
try {
    $jsonText = Get-Content -Path $localStatePath -Raw -Encoding Utf8
    $json = ConvertFrom-Json $jsonText
    
    # 修改 Variations Country
    $json.variations_country = "us"
    $json.variations_permanent_consistency_country = @("1", "us")
    
    # 递归修改 profile 下的 is_glic_eligible
    $modifiedProfilesCount = 0
    if ($json.profile -and $json.profile.info_cache) {
        $profiles = $json.profile.info_cache | Get-Member -MemberType NoteProperty
        foreach ($p in $profiles) {
            $pName = $p.Name
            $profileObj = $json.profile.info_cache.$pName
            if ($profileObj.is_glic_eligible -eq $null) {
                $profileObj | Add-Member -NotePropertyName "is_glic_eligible" -NotePropertyValue $true -Force
            } else {
                $profileObj.is_glic_eligible = $true
            }
            $modifiedProfilesCount++
            Write-Host "      已为配置文件 [$pName] 启用 GLIC AI 资格" -ForegroundColor Gray
        }
    }
    
    Write-Host "[4/5] 正在保存修改..." -ForegroundColor Yellow
    # 序列化为 JSON
    $newJsonText = $json | ConvertTo-Json -Depth 100
    
    # 使用无 BOM 的 UTF-8 编码写入文件（以契合 Chrome 默认编码）
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [IO.File]::WriteAllText($localStatePath, $newJsonText, $utf8NoBom)
    
    Write-Host "[5/5] [SUCCESS] 配置修改完成！" -ForegroundColor Green
    Write-Host ""
    Write-Host "==================================================" -ForegroundColor Green
    Write-Host " 恭喜！Chrome AI 功能（GLIC）已成功激活。" -ForegroundColor Green
    Write-Host " 现在您可以重新打开 Chrome 浏览器进行体验了。" -ForegroundColor Green
    Write-Host "==================================================" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "[错误] 修改或保存配置文件时出错：$_" -ForegroundColor Red
}

Read-Host "按回车键退出..."
