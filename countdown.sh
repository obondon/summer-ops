#!/bin/bash
count=5                               # 初始化计数器
while [ $count -gt 0 ]                # 当 count 大于 0 时继续
do
    echo "倒计时: $count"
    count=$((count - 1))              # count 减 1，$(( )) 是算术运算
done
echo "发射！"                         # 循环结束后执行

