#!/bin/bash
# for 循环三种用法

echo "=== 遍历列表 ==="
for name in liwei root admin; do           # 遍历空格分隔的列表
    echo "用户: $name"
done

echo "=== 遍历数字 ==="
for i in 1 2 3 4 5; do                     # 遍历数字列表
    echo "第 $i 次"
done

echo "=== 遍历文件 ==="
for f in *.sh; do                          # 遍历当前目录所有 .sh 文件
    echo "找到脚本: $f"
done

