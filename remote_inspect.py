import os
import paramiko

SERVERS = [                                    # 服务器清单
    {"name": "vm-01", "host": "localhost"},
    {"name": "vm-02", "host": "localhost"},
    {"name": "vm-03", "host": "localhost"},
]

THRESHOLDS = {"mem": 30, "disk": 80, "load": 2.0}   # 阈值：内存80% 磁盘80% 负载2.0（双核满载线）

def run(client, cmd):                          # 小工具：远程跑一条命令，把结果变成字符串
    stdin, stdout, stderr = client.exec_command(cmd)
    return stdout.read().decode()

def judge(item, value, threshold):             # 判定员：超阈值喊 WARNING，没超报 OK
    if value > threshold:
        return f"[WARNING] {item} {value}（阈值 {threshold}）"
    return f"[OK] {item} {value}（阈值 {threshold}）"

def inspect(server):                           # 查一台：连上→采三项指标→判定→关连接
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect(server["host"], username="liwei", password=os.environ["VM_PASSWORD"])

    # 内存：free 第2行按行号取（中文系统第1行是"内存："表头，按行号定位才稳——昨天Shell课的坑今天用上）
    parts = run(client, "free").splitlines()[1].split()
    total, avail = int(parts[1]), int(parts[6])     # 第1列总量，第6列可用（available）
    mem_pct = round((total - avail) / total * 100, 1)

    # 磁盘：df / 第2行第5列，形如"65%"，去掉%转数字
    disk_pct = float(run(client, "df /").splitlines()[1].split()[4].rstrip("%"))

    # 负载：uptime 倒数第3个数是1分钟负载，去掉尾巴逗号
    load1 = float(run(client, "uptime").split()[-3].rstrip(","))

    client.close()
    return [judge("内存", mem_pct, THRESHOLDS["mem"]),
            judge("磁盘", disk_pct, THRESHOLDS["disk"]),
            judge("负载", load1, THRESHOLDS["load"])]

for server in SERVERS:
    print(f"===== {server['name']} =====")
    for line in inspect(server):
        print(line)
