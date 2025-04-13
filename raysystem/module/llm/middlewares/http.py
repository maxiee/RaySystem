from module.llm.middlewares.context import ChatContext


async def http_tracking_middleware(context: ChatContext):
    """监控HTTP连接相关信息的中间件"""
    import json

    # 获取请求ID
    req_id = context.get("metadata", {}).get("request_id", "unknown")

    # 确保metadata存在
    if "metadata" not in context:
        context["metadata"] = {}

    if "network_info" not in context["metadata"]:
        context["metadata"]["network_info"] = {}

    network_info = context["metadata"]["network_info"]

    # 记录响应大小
    try:
        if raw_response := context.get("raw_openai_response"):
            if isinstance(raw_response, dict):
                # 估算响应大小
                try:
                    response_size = len(json.dumps(raw_response))
                    network_info["response_size_bytes"] = response_size

                    # 标记可能导致问题的大响应
                    if response_size > 1_000_000:  # 1MB
                        print(f"[HTTP-{req_id}] 警告: 响应过大 ({response_size} 字节)")
                except Exception:
                    pass
    except Exception as e:
        print(f"[HTTP-{req_id}] 获取网络信息错误: {e}")

    # 检查是否有响应消息
    if context.get("response_message") is None:
        print(f"[HTTP-{req_id}] 上下文中没有响应消息")

    # 检查是否有网络相关错误
    if error := context.get("error"):
        error_type = type(error).__name__
        error_msg = str(error)

        # 标记可能的网络问题
        network_related = any(
            term in error_msg.lower()
            for term in [
                "timeout",
                "connection",
                "network",
                "socket",
                "eof",
                "reset",
                "refused",
                "unavailable",
            ]
        )

        if network_related:
            print(
                f"[HTTP-{req_id}] 关键问题: 可能的网络问题: {error_type}: {error_msg}"
            )
            context["metadata"]["network_issue"] = True
            context["metadata"]["network_error"] = f"{error_type}: {error_msg}"
