import re
import subprocess
from typing import Optional, Tuple


class SystemUtils:
    @staticmethod
    def convert_to_gb(size: float, unit: str) -> float:
        """将不同单位的大小转换为 GB"""
        unit = unit.upper()
        if unit in ['B', 'BYTES']:
            return size / (1024 ** 3)
        elif unit in ['K', 'KB']:
            return size / (1024 ** 2)
        elif unit in ['M', 'MB']:
            return size / 1024
        elif unit in ['G', 'GB']:
            return size
        elif unit in ['T', 'TB']:
            return size * 1024
        else:
            raise ValueError(f"Unknown unit: {unit}")

    @staticmethod
    def get_volume_name(device: str, mount_point: str, volume_names_cache: dict) -> str:
        """获取磁盘的卷标名"""
        cache_key = f"{device}:{mount_point}"
        if cache_key in volume_names_cache:
            return volume_names_cache[cache_key]

        try:
            # 从设备路径中提取磁盘标识符
            disk_id = device.split('/')[-1]
            if not disk_id.startswith('disk'):
                return mount_point

            result = subprocess.run(
                ['diskutil', 'info', disk_id], 
                capture_output=True, 
                text=True
            )
            
            # 查找卷标名
            match = re.search(r'Volume Name:\s+(.+)', result.stdout)
            if (match):
                volume_name = match.group(1).strip()
            else:
                # 如果没有卷标名，使用挂载点的最后一部分
                volume_name = mount_point.split('/')[-1] or "Macintosh HD"

            volume_names_cache[cache_key] = volume_name
            return volume_name
        except (subprocess.SubprocessError, IndexError):
            return mount_point

    @staticmethod
    def get_apfs_volume_group_info(device: str) -> Optional[Tuple[str, str]]:
        """
        获取 APFS 卷组信息，返回 (container_id, volume_group_id)
        """
        try:
            # 获取磁盘标识符
            disk_id = device.split('/')[-1]
            if not disk_id.startswith('disk'):
                return None

            # 获取磁盘信息
            result = subprocess.run(
                ['diskutil', 'info', disk_id], 
                capture_output=True, 
                text=True,
                check=True
            )

            # 查找 APFS 卷组信息
            container_match = re.search(r'APFS Container:\s+(disk\d+)', result.stdout)
            volume_group_match = re.search(r'Volume Group:\s+([A-F0-9-]+)', result.stdout)

            if container_match and volume_group_match:
                return (container_match.group(1), volume_group_match.group(1))
            
            return None
        except Exception:
            return None

    @staticmethod
    def get_disk_usage(path: str) -> Optional[Tuple[float, float, float, float]]:
        """
        使用 statvfs 获取磁盘使用情况，返回与 macOS 一致的数据
        返回 (total_gb, used_gb, free_gb, usage_percent)
        """
        try:
            import os
            st = os.statvfs(path)
            
            # 计算总空间和可用空间（使用 f_bfree 而不是 f_bavail）
            total = st.f_blocks * st.f_frsize
            free = st.f_bfree * st.f_frsize  # 使用 f_bfree 替代 f_bavail
            used = total - free
            
            # 转换为 GB 和百分比
            total_gb = total / (1024 ** 3)
            used_gb = used / (1024 ** 3)
            free_gb = free / (1024 ** 3)
            usage_percent = (used / total * 100) if total > 0 else 0
            
            return (total_gb, used_gb, free_gb, usage_percent)
        except Exception as e:
            print(f"Error getting disk usage: {e}")
            return None

    @staticmethod
    def get_macos_disk_usage(device: str) -> Optional[Tuple[float, float, float, float]]:
        """
        使用 diskutil 命令获取 macOS 的磁盘使用情况
        返回 (total_gb, used_gb, free_gb, usage_percent)
        """
        try:
            # 从设备路径中提取磁盘标识符
            disk_id = device.split('/')[-1]
            if not disk_id.startswith('disk'):
                return None

            # 首先尝试获取卷组信息
            group_info = SystemUtils.get_apfs_volume_group_info(device)
            if group_info:
                container_id, _ = group_info
            else:
                # 如果没有卷组信息，尝试获取容器信息
                result = subprocess.run(
                    ['diskutil', 'info', disk_id], 
                    capture_output=True, 
                    text=True,
                    check=True
                )
                container_match = re.search(r'APFS Container:\s+(disk\d+)', result.stdout)
                if container_match:
                    container_id = container_match.group(1)
                else:
                    return None

            # 获取容器信息
            result = subprocess.run(
                ['diskutil', 'apfs', 'list'], 
                capture_output=True, 
                text=True,
                check=True
            )

            # 解析容器信息
            lines = result.stdout.split('\n')
            container_info = None
            capacity = None
            free = None
            
            for i, line in enumerate(lines):
                if container_id in line:
                    # 找到目标容器，解析其容量信息
                    for j in range(i, min(i + 10, len(lines))):
                        if 'Capacity Ceiling:' in lines[j]:
                            capacity_match = re.search(r'(\d+\.?\d*)\s*(\w+)', lines[j])
                            if capacity_match:
                                size, unit = capacity_match.groups()
                                capacity = SystemUtils.convert_to_gb(float(size), unit)
                        elif 'Free Space:' in lines[j]:
                            free_match = re.search(r'(\d+\.?\d*)\s*(\w+)', lines[j])
                            if free_match:
                                size, unit = free_match.groups()
                                free = SystemUtils.convert_to_gb(float(size), unit)
                        
                        if capacity is not None and free is not None:
                            break

            if capacity is not None and free is not None:
                used = capacity - free
                usage_percent = (used / capacity) * 100 if capacity > 0 else 0
                return (capacity, used, free, usage_percent)
            
            return None
            
        except Exception as e:
            print(f"Error getting disk usage: {e}")
            return None