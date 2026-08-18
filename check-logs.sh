#!/bin/bash
set -eu                          # 出错即停 + 未定义变量报错

# 模拟一批日志文件路径
logs=(
    "/var/log/nginx/access.log"
    "/var/log/nginx/error.log"
    "/var/log/syslog"
    "/var/log/auth.log"
)

echo "=== 日志检查开始 ==="

# 遍历每个日志路径
for logfile in "${logs[@]}"; do
    filename="${logfile##*/}"     # 取文件名（删头部最长匹配 */）
    dirname="${logfile%/*}"       # 取目录名（删尾部最短匹配 /*）
    suffix="${filename##*.}"     # 取后缀（删头部最长匹配 *.）
    basename="${filename%.*}"     # 取不带后缀的文件名（删尾部最短匹配 .*）

    echo "路径:   $logfile"
    echo "  目录:   $dirname"
    echo "  文件名: $filename"
    echo "  基础名: $basename"
    echo "  后缀:   $suffix"
    echo ""
done

echo "=== 检查完毕，共 ${#logs[@]} 个文件 ==="
