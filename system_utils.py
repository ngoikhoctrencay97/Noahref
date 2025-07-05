import os
import psutil

def get_system_info():
    info = ""
    for partition in psutil.disk_partitions(all=False):
        try:
            if not os.path.exists(partition.mountpoint):
                continue  # Skip if mount point does not exist
            usage = psutil.disk_usage(partition.mountpoint)
            info += f"{partition.device} mounted on {partition.mountpoint}: {usage.percent}% used\n"
        except (FileNotFoundError, PermissionError):
            continue
    return info
