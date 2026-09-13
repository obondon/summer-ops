# Summer Ops — 服务器巡检自动化工具

> 从单机 Shell 脚本到容器化部署的完整迭代，共 4 个演进版本。
> 暑期 Linux 运维学习项目的最终产出，代码全程 Git 管理。

## 项目背景

服务器日常巡检（CPU、内存、磁盘、服务运行状态、SSH 安全等）手工逐台检查效率低、易漏项。本项目以"一条命令完成巡检"为目标，围绕**单机 → 多机 → 容器化**三条主线迭代了 4 个版本。

## 演进路线

```
v1 sys_inspect.sh    单机巡检脚本（Shell）
        ↓ 重构
v2 sys_inspect.py    Python 重构，扩展异常判断逻辑
        ↓ 扩展
v3 remote_inspect.py paramiko 批量远程巡检（多机一条命令）
        ↓ 封装
v4 Dockerfile        容器化交付，开箱即用
```

| 版本 | 文件 | 做了什么 |
|------|------|---------|
| v1 | `sys_inspect.sh` | 单机巡检：CPU / 内存 / 磁盘 / 用户 / SSH 安全指标采集与阈值告警 |
| v2 | `sys_inspect.py` | Python 重构：异常判断逻辑更清晰，输出格式统一 |
| v3 | `remote_inspect.py` | 引入 paramiko：批量远程巡检，多台服务器一条命令跑完 |
| v4 | `Dockerfile` | 工具容器化：`docker build` + `docker run` 开箱即用 |

## 快速开始

```bash
# v1 单机巡检
./sys_inspect.sh

# v3 批量巡检（主机列表见脚本内配置）
python3 remote_inspect.py

# v4 容器化
docker build -t sys-inspect:1.0 .
docker run --rm sys-inspect:1.0
```

## 学习期练习脚本

以下为 Shell 学习期的练习作品，保留作为学习轨迹：

| 脚本 | 练习点 |
|------|--------|
| `hello.sh` | 第一个脚本 |
| `greet.sh` | 位置参数 |
| `compare.sh` | 条件判断 |
| `loop.sh` | for 循环 |
| `countdown.sh` | while 循环 |
| `check.sh` | 文件测试 |
| `menu.sh` | 菜单分支 |
| `check-logs.sh` | 日志路径解析 |
| `syscheck.sh` | 系统检查 |
| `debug-demo.sh` | 调试技巧 |

## 技术要点

- Shell：文本三剑客（grep/awk/sed）、管道与重定向、退出码判断
- Python：subprocess 调用系统命令、阈值判断逻辑、输出格式化
- paramiko：SSH 连接复用、批量执行与结果汇总
- Docker：镜像分层、最小化构建

---

*2026 暑期 · 电子信息科学与技术专业 · 面向通信网络运维方向*
