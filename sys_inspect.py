#!/usr/bin/env python3
# sys_inspect.py —— 系统巡检 Python 版（对照 DAY 18 的 sys_inspect.sh）

import time                              # time.sleep(1) 对应 Shell 的 sleep 1
import shutil
import subprocess

def check_cpu():
    # CPU 使用率：读 /proc/stat 采两次样算差值，和 Shell 版同一招
    with open("/proc/stat") as f:        # with 打开文件，用完自动关
        cols = f.readline().split()      # 第一行按空格拆成列表
    a = [int(x) for x in cols[1:]]       # 跳过 "cpu" 标签全转整数（列表推导式，先照抄不展开）
    time.sleep(1)                        # 隔 1 秒再采第二次
    with open("/proc/stat") as f:
        cols = f.readline().split()
    b = [int(x) for x in cols[1:]]
    idle  = b[3] - a[3]                  # 空闲时间的增量（第4列是 idle）
    total = sum(b) - sum(a)              # 总时间增量（sum = 列表所有元素求和）
    usage = 100 * (total - idle) / total
    if usage > 90:
        print(f"[CPU ] 使用率 {usage:.1f}%  ⚠ 超过 90%，告警！")
    else:
        print(f"[CPU ] 使用率 {usage:.1f}%  ✓ 正常")

def check_mem():
    # 内存使用率：读 /proc/meminfo，对照 Shell 的 free | sed -n '2p'
    info = {}                            # 空字典
    with open("/proc/meminfo") as f:
        for line in f:                   # 逐行读
            cols = line.split()          # "MemTotal:  4032600 kB" → 3 个元素
            info[cols[0].rstrip(":")] = int(cols[1])   # 去冒号，存数字
    total = info["MemTotal"]             # 总内存（单位 kB）
    avail = info["MemAvailable"]         # 可用内存
    usage = 100 * (total - avail) / total
    if usage > 80:
        print(f"[内存] 使用率 {usage:.1f}%  ⚠ 超过 80%，告警！")
    else:
        print(f"[内存] 使用率 {usage:.1f}%  ✓ 正常")

def check_disk(): 
    du = shutil.disk_usage("/")
    usage = 100 * du.used / du.total
    if usage > 85:
        print(f"[磁盘] 使用率 {usage:.1f}%  ⚠ 超过 85%，告警！")
    else:
        print(f"[磁盘] 使用率 {usage:.1f}%  ✓ 正常")

def check_users():
    r = subprocess.run(["w", "-h"], capture_output=True, text=True)
    users = r.stdout.splitlines() 
    print(f"用户数为 {len(users)}")

def main():
    # 总调度：报告打头，逐项检查，单项炸了不连坐
    print("=" * 40)
    print("      系统巡检报告（Python 版）")
    print("=" * 40)
    try:
        check_cpu()
    except Exception as e:               # e 里装着报错原因
        print(f"[CPU ] 检查失败: {e}")
    try:
        check_mem()
    except Exception as e:
        print(f"[内存] 检查失败: {e}")
    try:
        check_disk()
    except Exception as e:
        print(f"[磁盘] 检查失败: {e}")
    try:
        check_users()
    except Exception as e:
        print(f"[用户] 检查失败: {e}")




main()                                   # 跑起来
