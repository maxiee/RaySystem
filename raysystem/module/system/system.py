import psutil
import subprocess
import re
from dataclasses import dataclass
from typing import Dict, List, Optional, Tuple, Set


@dataclass
class DiskMetrics:
    device: str
    mount_point: str
    volume_name: str  # 新增：卷标名
    total_gb: float
    used_gb: float
    free_gb: float
    usage_percent: float
    read_speed_mb: float
    write_speed_mb: float


@dataclass
class NetworkMetrics:
    upload_speed_mb: float
    download_speed_mb: float


@dataclass
class MemoryMetrics:
    total_gb: float
    used_gb: float
    available_gb: float
    cached_gb: float  # 新增：缓存内存
    percent: float
    swap_total_gb: float  # 新增：交换内存总量
    swap_used_gb: float   # 新增：已用交换内存
    swap_free_gb: float   # 新增：可用交换内存
    swap_percent: float   # 新增：交换内存使用率


@dataclass
class SystemMetrics:
    cpu_percent: float
    memory: MemoryMetrics  # 修改：使用新的内存指标类
    disks: List[DiskMetrics]
    network: NetworkMetrics


class SystemMonitor:
    def __init__(self):
        self._disk_io_last = None
        self._net_io_last = None
        self._volume_names_cache = {}  # 缓存卷标名，避免频繁调用 diskutil

    def _get_disk_io_speeds(self) -> Dict[str, tuple[float, float]]:
        """Calculate disk IO speeds in MB/s"""
        current = psutil.disk_io_counters(perdisk=True)
        if self._disk_io_last is None:
            self._disk_io_last = current
            return {disk: (0.0, 0.0) for disk in current.keys()}

        disk_speeds = {}
        for disk in current.keys():
            if disk in self._disk_io_last:
                # Calculate read speed
                read_bytes = current[disk].read_bytes - self._disk_io_last[disk].read_bytes
                write_bytes = current[disk].write_bytes - self._disk_io_last[disk].write_bytes
                # Convert to MB/s
                read_mb = read_bytes / 1024 / 1024
                write_mb = write_bytes / 1024 / 1024
                disk_speeds[disk] = (read_mb, write_mb)
            else:
                disk_speeds[disk] = (0.0, 0.0)

        self._disk_io_last = current
        return disk_speeds

    def _get_network_speeds(self) -> tuple[float, float]:
        """Calculate network speeds in MB/s"""
        current = psutil.net_io_counters()
        if self._net_io_last is None:
            self._net_io_last = current
            return 0.0, 0.0

        # Calculate speeds
        upload_bytes = current.bytes_sent - self._net_io_last.bytes_sent
        download_bytes = current.bytes_recv - self._net_io_last.bytes_recv
        
        # Convert to MB/s
        upload_mb = upload_bytes / 1024 / 1024
        download_mb = download_bytes / 1024 / 1024

        self._net_io_last = current
        return upload_mb, download_mb

    def _get_memory_metrics(self) -> MemoryMetrics:
        """Get detailed memory metrics"""
        virtual_memory = psutil.virtual_memory()
        swap = psutil.swap_memory()

        # Calculate memory values in GB
        total_gb = virtual_memory.total / (1024 ** 3)
        used_gb = (virtual_memory.total - virtual_memory.available) / (1024 ** 3)  # 实际使用的内存
        available_gb = virtual_memory.available / (1024 ** 3)
        # 在 macOS 中，cached 可能包含在 active/inactive 中
        cached_gb = getattr(virtual_memory, 'cached', 0) / (1024 ** 3)
        
        # Swap memory
        swap_total_gb = swap.total / (1024 ** 3)
        swap_used_gb = swap.used / (1024 ** 3)
        swap_free_gb = swap.free / (1024 ** 3)
        swap_percent = swap.percent

        return MemoryMetrics(
            total_gb=total_gb,
            used_gb=used_gb,
            available_gb=available_gb,
            cached_gb=cached_gb,
            percent=virtual_memory.percent,
            swap_total_gb=swap_total_gb,
            swap_used_gb=swap_used_gb,
            swap_free_gb=swap_free_gb,
            swap_percent=swap_percent
        )

    def _is_physical_disk(self, partition) -> bool:
        """判断是否为物理磁盘的主要挂载点"""
        # 检查文件系统类型
        if partition.fstype not in ['apfs', 'hfs', 'exfat', 'ntfs', 'msdos', 'fat32']:
            return False
            
        # macOS 上只关注主要挂载点和外接磁盘
        valid_mounts = [
            '/',                    # 系统主分区
            '/System/Volumes/Data', # macOS 数据分区
            '/Volumes'             # 外接磁盘目录
        ]
        
        # 检查是否是主要挂载点或外接磁盘
        if partition.mountpoint in valid_mounts or partition.mountpoint.startswith('/Volumes/'):
            # 排除系统相关的特殊挂载点
            if any(x in partition.mountpoint.lower() for x in [
                'preboot', 'vm', 'update', 'xarts', 'isc', 
                'simulator', 'cryptex', '.timemachine'
            ]):
                return False
            return True
            
        return False

    def _get_df_disk_usage(self, path: str) -> Optional[tuple[float, float, float, float]]:
        """
        使用 df 命令获取磁盘使用情况，返回 (total_gb, used_gb, free_gb, usage_percent)
        """
        try:
            # -P: 使用 POSIX 格式输出
            # -k: 以千字节为单位
            # -l: 只显示本地文件系统
            result = subprocess.run(['df', '-Pkl', path], capture_output=True, text=True, check=True)
            lines = result.stdout.strip().split('\n')
            if len(lines) < 2:  # 至少需要标题行和数据行
                return None
                
            # 解析输出的数据行
            data = lines[1].split()
            if len(data) < 5:
                return None
                
            # 转换单位到 GB
            total_kb = float(data[1])
            used_kb = float(data[2])
            free_kb = float(data[3])
            usage_percent = float(data[4].rstrip('%'))
            
            return (
                total_kb / (1024 * 1024),  # 转换为 GB
                used_kb / (1024 * 1024),
                free_kb / (1024 * 1024),
                usage_percent
            )
        except (subprocess.SubprocessError, ValueError, IndexError):
            return None

    def _get_apfs_volume_group_info(self, device: str) -> Optional[tuple[str, str]]:
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

    def _get_grouped_partitions(self, partitions) -> List[List]:
        """
        将属于同一个 APFS 卷组的分区分组
        """
        groups = {}
        ungrouped = []

        for partition in partitions:
            if not self._is_physical_disk(partition):
                continue

            group_info = self._get_apfs_volume_group_info(partition.device)
            if group_info:
                container_id, group_id = group_info
                key = f"{container_id}:{group_id}"
                if key not in groups:
                    groups[key] = []
                groups[key].append(partition)
            else:
                ungrouped.append([partition])

        return list(groups.values()) + ungrouped

    def _get_macos_disk_usage(self, device: str) -> Optional[tuple[float, float, float, float]]:
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
            group_info = self._get_apfs_volume_group_info(device)
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
                                capacity = self._convert_to_gb(float(size), unit)
                        elif 'Free Space:' in lines[j]:
                            free_match = re.search(r'(\d+\.?\d*)\s*(\w+)', lines[j])
                            if free_match:
                                size, unit = free_match.groups()
                                free = self._convert_to_gb(float(size), unit)
                        
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

    def _convert_to_gb(self, size: float, unit: str) -> float:
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

    def _get_volume_name(self, device: str, mount_point: str) -> str:
        """获取磁盘的卷标名"""
        cache_key = f"{device}:{mount_point}"
        if cache_key in self._volume_names_cache:
            return self._volume_names_cache[cache_key]

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

            self._volume_names_cache[cache_key] = volume_name
            return volume_name
        except (subprocess.SubprocessError, IndexError):
            return mount_point

    def get_metrics(self) -> SystemMetrics:
        """Get current system metrics"""
        # CPU usage
        cpu_percent = psutil.cpu_percent(interval=1)

        # Memory metrics
        memory = self._get_memory_metrics()

        # Disk usage and IO
        disk_partitions = psutil.disk_partitions()
        disk_io_speeds = self._get_disk_io_speeds()
        disks = []

        # 按卷组对分区进行分组
        partition_groups = self._get_grouped_partitions(disk_partitions)
        processed_groups = set()  # 用于跟踪已处理的卷组

        for group in partition_groups:
            if not group:
                continue

            # 使用组中第一个分区作为主分区
            main_partition = group[0]
            group_info = self._get_apfs_volume_group_info(main_partition.device)
            
            if group_info:
                container_id, group_id = group_info
                group_key = f"{container_id}:{group_id}"
                if group_key in processed_groups:
                    continue
                processed_groups.add(group_key)

            # 获取卷标名和使用情况
            volume_name = self._get_volume_name(main_partition.device, main_partition.mountpoint)
            macos_usage = self._get_macos_disk_usage(main_partition.device)

            if macos_usage:
                total_gb, used_gb, free_gb, usage_percent = macos_usage
            else:
                # 回退到使用 df 命令
                df_usage = self._get_df_disk_usage(main_partition.mountpoint)
                if df_usage:
                    total_gb, used_gb, free_gb, usage_percent = df_usage
                else:
                    usage = psutil.disk_usage(main_partition.mountpoint)
                    total_gb = usage.total / (1024 ** 3)
                    used_gb = usage.used / (1024 ** 3)
                    free_gb = usage.free / (1024 ** 3)
                    usage_percent = usage.percent

            # 获取磁盘 IO 速度
            device_name = main_partition.device.split('/')[-1]
            read_speed, write_speed = disk_io_speeds.get(device_name, (0.0, 0.0))

            disk = DiskMetrics(
                device=main_partition.device,
                mount_point=main_partition.mountpoint,
                volume_name=volume_name,
                total_gb=total_gb,
                used_gb=used_gb,
                free_gb=free_gb,
                usage_percent=usage_percent,
                read_speed_mb=read_speed,
                write_speed_mb=write_speed
            )
            disks.append(disk)

        # Network speeds
        upload_speed, download_speed = self._get_network_speeds()
        network = NetworkMetrics(
            upload_speed_mb=upload_speed,
            download_speed_mb=download_speed
        )

        return SystemMetrics(
            cpu_percent=cpu_percent,
            memory=memory,
            disks=disks,
            network=network
        )


# Global instance for system monitoring
_system_monitor = None


def get_system_metrics() -> SystemMetrics:
    """Get current system metrics"""
    global _system_monitor
    if (_system_monitor is None):
        _system_monitor = SystemMonitor()
    return _system_monitor.get_metrics()