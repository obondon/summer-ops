#!/bin/bash
echo "=== 运维工具菜单 ==="
echo "1. 查看磁盘  (df -h)"
echo "2. 查看内存  (free -m)"
echo "3. 查看负载  (uptime)"
echo "4. 退出"
read -p "请选择 [1-4]: " choice     # read 接收用户输入，存入 choice 变量

case $choice in
    1)
        df -h                        # 查看磁盘使用情况
        ;;
    2)
        free -m                      # 查看内存使用情况（MB为单位）
        ;;
    3)
        uptime                       # 查看系统运行时间和负载
        ;;
    4)
        echo "再见"
        exit 0                       # exit 0 正常退出脚本
        ;;
    *)                               # 其他所有输入
        echo "无效选择: $choice"
        ;;
esac

