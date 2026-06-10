# Enable Chrome GLIC in CN

一键激活 Google Chrome 浏览器在中国地区的全新 Gemini AI 侧边栏 (GLIC) 功能。支持 Windows 和 macOS 平台，提供全自动的配置脚本。

* 🌐 **项目发布主页** (已托管在 GitHub Pages): `https://frankiechan-CYP.github.io/enable_chrome_glic_in_cn/`

---

## 🛠️ 技术原理 (Technical Principles)

Google Chrome 浏览器的 AI 侧边栏功能 (GLIC) 对部分地区的用户有限制。本项目通过修改 Chrome 全局配置文件 `Local State` 的核心字段，强行激活该功能：

| 配置文件名 | 字段 (JSON Key) | 修改目标值 (Value) | 作用 |
| :--- | :--- | :--- | :--- |
| `Local State` | `variations_country` | `"us"` | 设置用户国家为美国 |
| `Local State` | `variations_permanent_consistency_country` | `["1", "us"]` | 设置永久一致性国家为美国 |
| `Local State` | `is_glic_eligible` | `true` | 对所有配置文件启用 GLIC 功能资格 |

---

## 🚀 快速开始 (Usage)

### Windows 平台
1. 下载/克隆本仓库到本地。
2. 进入 `scripts/` 目录。
3. 右键点击 `win_enable_glic.bat`，选择 **以管理员身份运行**（或者直接双击运行）。
4. 运行完成后重启 Chrome 浏览器即可！

### macOS 平台
1. 打开“终端 (Terminal)”。
2. 切换到本仓库所在的 `scripts/` 目录下。
3. 执行以下命令：
   ```bash
   chmod +x mac_enable_glic.sh && ./mac_enable_glic.sh
   ```
4. 运行完成后重启 Chrome 浏览器即可！

---

## ⚠️ 注意事项与备份 (Backup & Notes)
* 本脚本在执行任何写操作前，**均会自动备份**当前的 `Local State` 配置文件，备份格式为 `Local State.backup.时间戳`。如遇到任何异常，直接将备份文件重命名回 `Local State` 覆盖即可还原。
* 运行脚本时会自动强行关闭当前正在运行的 Chrome 进程，以确保写入的新配置生效且不被覆盖，因此请在运行前保存您网页上的未完工作。

---

## 📄 许可证
本项目采用 MIT 许可证开源。仅供学习交流与个人研究使用。
