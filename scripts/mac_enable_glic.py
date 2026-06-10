#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# macOS/Linux Python Script to enable Google Chrome AI features (GLIC)
# Project: enable-chrome-glic-in-cn
# GitHub: https://github.com/your-username/enable_chrome_glic_in_cn

import os
import json
import sys
import shutil
import datetime
import subprocess

def print_cyan(text):
    print(f"\033[96m{text}\033[0m")

def print_green(text):
    print(f"\033[92m{text}\033[0m")

def print_yellow(text):
    print(f"\033[93m{text}\033[0m")

def print_red(text):
    print(f"\033[91m{text}\033[0m")

def print_gray(text):
    print(f"\033[90m{text}\033[0m")

def kill_chrome_mac():
    print_yellow("[1/5] 正在关闭所有 Chrome 浏览器进程...")
    try:
        # Gracefully ask Chrome to quit or terminate it
        subprocess.run(["pkill", "-f", "Google Chrome"], capture_output=True)
        print_green("[SUCCESS] 已尝试关闭 Chrome 浏览器进程。")
    except Exception as e:
        print_gray(f"[INFO] 尝试关闭进程时发生错误: {e}")

def modify_json_recursively(d, key_target, value_target):
    modified_count = 0
    if isinstance(d, dict):
        for k, v in list(d.items()):
            if k == key_target:
                d[k] = value_target
                modified_count += 1
            else:
                modified_count += modify_json_recursively(v, key_target, value_target)
    elif isinstance(d, list):
        for item in d:
            modified_count += modify_json_recursively(item, key_target, value_target)
    return modified_count

def main():
    print_cyan("==================================================")
    print_cyan("         正在启用 Google Chrome AI (GLIC)        ")
    print_cyan("==================================================")
    print()

    # Determine Local State Path for macOS
    home = os.path.expanduser("~")
    local_state_path = os.path.join(home, "Library", "Application Support", "Google", "Chrome", "Local State")

    # If on Linux (for compatibility)
    if sys.platform.startswith("linux"):
        local_state_path = os.path.join(home, ".config", "google-chrome", "Local State")

    if not os.path.exists(local_state_path):
        print_red(f"[错误] 找不到 Chrome Local State 配置文件，路径为：{local_state_path}")
        print_red("请确认您的 Mac 上已安装 Google Chrome 浏览器。")
        sys.exit(1)

    # 1. Close Chrome
    kill_chrome_mac()

    # 2. Create Backup
    print_yellow("[2/5] 正在创建原配置文件的备份...")
    timestamp = datetime.datetime.now().strftime("%Y%m%d%H%M%S")
    backup_path = f"{local_state_path}.backup.{timestamp}"
    try:
        shutil.copy2(local_state_path, backup_path)
        print_green(f"[SUCCESS] 已创建备份: {backup_path}")
    except Exception as e:
        print_red(f"[错误] 创建备份失败: {e}")
        sys.exit(1)

    # 3. Read and modify JSON
    print_yellow("[3/5] 正在读取并修改配置文件...")
    try:
        with open(local_state_path, 'r', encoding='utf-8') as f:
            data = json.load(f)

        # Set country
        data['variations_country'] = 'us'
        print_green("[SUCCESS] 设置 variations_country = \"us\"")

        data['variations_permanent_consistency_country'] = ["1", "us"]
        print_green("[SUCCESS] 设置 variations_permanent_consistency_country = [\"1\", \"us\"]")

        # Recursively change/add is_glic_eligible
        modified_glic = modify_json_recursively(data, 'is_glic_eligible', True)
        
        # Inject if missing
        if modified_glic == 0:
            profiles = data.get('profile', {}).get('info_cache', {})
            for profile_name, profile_data in profiles.items():
                profile_data['is_glic_eligible'] = True
                modified_glic += 1
                print_gray(f"      已为配置文件 [{profile_name}] 新增 GLIC AI 资格")

        print_green(f"[SUCCESS] 设置所有 is_glic_eligible = true (共修改/新增 {modified_glic} 处)")

        # 4. Save file
        print_yellow("[4/5] 正在保存修改...")
        with open(local_state_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)

        print_green("[5/5] [SUCCESS] 配置修改完成！")
        print()
        print_cyan("==================================================")
        print_cyan(" 恭喜！Mac Chrome AI 功能（GLIC）已成功激活。")
        print_cyan(" 现在您可以重新打开 Chrome 浏览器进行体验了。")
        print_cyan("==================================================")
        print()

    except Exception as e:
        print_red(f"[错误] 处理配置文件时发生异常: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
