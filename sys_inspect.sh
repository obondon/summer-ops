#!/bin/bash

# 系统巡检脚本 sys_inspect.sh
# 作者: 李威

# ===== 全局变量 =====
WARN_CPU=80
WARN_MEM=80
WARN_DISK=85
WARN_USER=3
WARN_SSH_FAIL=10

# ===== 函数定义 =====
check_cpu() {
    # /proc/stat 第一行是CPU汇总，格式: cpu user nice system idle ...
    # 第一次采样
    read -r _ cpu_user1 cpu_nice1 cpu_sys1 cpu_idle1 rest1 < /proc/stat
    total1=$((cpu_user1 + cpu_nice1 + cpu_sys1 + cpu_idle1))
    
    # sleep 1 间隔1秒再采第二次
    sleep 1
    read -r _ cpu_user2 cpu_nice2 cpu_sys2 cpu_idle2 rest2 < /proc/stat
    total2=$((cpu_user2 + cpu_nice2 + cpu_sys2 + cpu_idle2))
    
    # 计算差值: 使用率 = (总时间差 - 空闲差) / 总时间差 * 100
    total_diff=$((total2 - total1))
    idle_diff=$((cpu_idle2 - cpu_idle1))
    cpu_usage=$(( (total_diff - idle_diff) * 100 / total_diff ))
    
    if [ "$cpu_usage" -ge $WARN_CPU ]; then
        echo "CPU检查: ${cpu_usage}% 使用率 [⚠告警! 超过${WARN_CPU}%]"
    else
        echo "CPU检查: ${cpu_usage}% 使用率 [正常]"
    fi
}

check_mem() {
    mem_total=$(free | sed -n '2p' | awk '{print $2}')
    mem_avail=$(free | sed -n '2p' | awk '{print $7}')
    mem_usage=$(echo "scale=1; ($mem_total - $mem_avail) * 100 / $mem_total" | bc)
    
    if [ ${mem_usage%.*} -ge $WARN_MEM ]; then
        echo "内存检查: ${mem_usage}% 使用率 [⚠告警! 超过${WARN_MEM}%]"
    else
        echo "内存检查: ${mem_usage}% 使用率 [正常]"
    fi
}

check_disk() {
    echo "磁盘检查:"
    df -h | tail -n +2 | while read line; do
        partition=$(echo "$line" | awk '{print $1}')
        usage=$(echo "$line" | awk '{print $5}' | tr -d '%')
        
        if [ -n "$usage" ] && [ "$usage" != "0" ]; then
            if [ "$usage" -ge $WARN_DISK ]; then
                echo "  $partition: ${usage}% [⚠告警! 超过${WARN_DISK}%]"
            else
                echo "  $partition: ${usage}% [正常]"
            fi
        fi
    done
}

check_user() {
    # who 每行是一个登录会话，wc -l 数行数
    user_count=$(who | wc -l)
    
    if [ "$user_count" -ge $WARN_USER ]; then
        echo "用户检查: ${user_count}人在线 [⚠告警! 超过${WARN_USER}人]"
    else
        echo "用户检查: ${user_count}人在线 [正常]"
    fi
}

check_ssh() {
    # /var/log/auth.log 记录SSH登录日志
    # date '+%b %d' 生成今天日期如 "Aug 12"，用于过滤今天的日志
    today=$(date '+%b %d')
    
    # grep Failed 过滤失败记录，wc -l 数行数
    # 2>/dev/null 如果日志文件不存在不报错，静默丢弃错误信息
    fail_count=$(sudo grep "$today" /var/log/auth.log 2>/dev/null | grep "Failed" | wc -l)
    
    if [ "$fail_count" -ge $WARN_SSH_FAIL ]; then
        echo "SSH安全检查: 今日失败${fail_count}次 [⚠告警! 可能被暴力破解]"
    else
        echo "SSH安全检查: 今日失败${fail_count}次 [正常]"
    fi
}

# ===== 主流程 =====
echo "========================================"
echo "    系统巡检报告 - $(date '+%Y-%m-%d %H:%M:%S')"
echo "    主机名: $(hostname)"
echo "========================================"
echo ""

check_cpu
check_mem
check_disk
check_user
check_ssh

echo ""
echo "========================================"
echo "    巡检完成"
echo "========================================"
