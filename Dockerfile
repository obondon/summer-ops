# sys_inspect 容器化打包  作者:李威  DAY 30
FROM python:3-slim

WORKDIR /app

# 装 procps 提供 w 命令（check_users 调用）
# procps 还含 free/ps/top 等常用运维命令，装了不亏
RUN apt-get update && apt-get install -y --no-install-recommends procps \
    && rm -rf /var/lib/apt/lists/*

COPY sys_inspect.py .

CMD ["python3", "sys_inspect.py"]
