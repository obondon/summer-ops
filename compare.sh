#!/bin/bash
# 字符串比较 + 数字比较

user1="liwei"
user2="root"
echo "user1=$user1, user2=$user2"

if [ "$user1" = "$user2" ]; then          # 字符串相等比较用 =（不是 ==）
    echo "两个用户名相同"
else
    echo "两个用户名不同"
fi

if [ -n "$user1" ]; then                  # -n：字符串非空
    echo "user1 不为空"
fi

score=85

if [ $score -ge 90 ]; then                # -ge：大于等于（数字比较）
    echo "优秀"
elif [ $score -ge 80 ]; then              # 80-89
    echo "良好"
elif [ $score -ge 60 ]; then              # 60-79
    echo "及格"
else
    echo "不及格"
fi

