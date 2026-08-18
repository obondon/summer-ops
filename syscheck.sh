#!/bin/bash

# 定义函数：检查服务是否在运行
check_service() {
    local svc=$1                    # local 声明局部变量，$1 是函数收到的第一个参数
    if systemctl is-active --quiet $svc; then   # --quiet 安静模式，不输出
        echo "✓ $svc 正在运行"
    else
        echo "✗ $svc 未运行"
    fi
}

# 定义函数：打印分隔线
print_line() {
    echo "-------------------------------"
}

# 调用函数
print_line
echo "系统服务检查"
print_line
check_service ssh                    # 检查 SSH 服务
check_service cron                   # 检查定时任务服务
check_service nginx                  # 检查 nginx（大概率没装，会显示未运行）
print_line

