#!/bin/bash
# 文件测试脚本

file="hello.sh"

if [ -f "$file" ]; then                    # -f：文件存在且是普通文件
    echo "$file 存在"
    if [ -x "$file" ]; then                # -x：文件有可执行权限
        echo "$file 可执行"
    else
        echo "$file 不可执行"
    fi
else
    echo "$file 不存在"
fi

