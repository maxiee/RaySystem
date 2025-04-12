from typing import Dict, List, Any, Callable, Awaitable, TypedDict, Optional, Union


# Type for chat context dictionary
class ChatContext(TypedDict, total=False):
    """Context passed through middleware chain during LLM operations."""

    request_messages: List[Dict[str, Any]]  # List of message dictionaries
    model: str  # Model identifier to send to the API
    model_config_name: str  # Name of model config in our system
    response_message: Any  # The response message object
    raw_openai_response: Optional[Dict[str, Any]]  # Full raw response from OpenAI
    error: Optional[Exception]  # Any error that occurred
    metadata: Dict[str, Any]  # Metadata for middleware communication


# Type for middleware function
LLMMiddleware = Callable[[ChatContext], Awaitable[None]]


async def apply_middleware(
    middleware_list: List[LLMMiddleware], context: ChatContext
) -> None:
    """
    Apply a list of middleware functions to the LLM context.

    Args:
        middleware_list: List of middleware functions to apply
        context: The context object to pass through the middleware chain
    """
    for middleware in middleware_list:
        try:
            await middleware(context)
        except Exception as e:
            print(f"Error in middleware {middleware.__name__}: {e}")
            # Only set the error if not already set
            if context.get("error") is None:
                context["error"] = e


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


async def response_validation_middleware(context: ChatContext):
    """验证响应内容格式的中间件，确保响应可以正确序列化"""
    import json

    # 如果没有响应消息则跳过
    if not context.get("response_message"):
        return

    req_id = context.get("metadata", {}).get("request_id", "unknown")

    # 确保metadata存在
    if "metadata" not in context:
        context["metadata"] = {}

    # 获取响应内容
    response = context.get("response_message")
    content = getattr(response, "content", "") if response else ""

    if not content:
        print(f"[验证-{req_id}] 警告: 响应内容为空")
        return

    # 检查常见导致序列化问题的内容模式
    issues = []

    # 检查JSON括号是否匹配
    if content.count("{") != content.count("}"):
        issues.append("JSON大括号不匹配")
    if content.count("[") != content.count("]"):
        issues.append("JSON方括号不匹配")

    # 检查控制字符
    if any(ord(c) < 32 and c not in "\n\r\t" for c in content):
        issues.append("存在控制字符")

    # 检查长行
    if any(len(line) > 10000 for line in content.split("\n")):
        issues.append("存在超长行")

    # 记录发现的问题
    for issue in issues:
        print(f"[验证-{req_id}] 警告: {issue}")
        context["metadata"].setdefault("validation_warnings", []).append(issue)

    # 测试完整序列化
    try:
        # 尝试序列化完整响应以验证其工作正常
        response_dict = {
            "message": {
                "role": getattr(response, "role", "assistant"),
                "content": content,
            },
            "model_used": context.get("model_config_name", ""),
        }

        # 测试JSON序列化
        json_str = json.dumps(response_dict)
        json_size = len(json_str)

        # 检查过大的响应
        if json_size > 5_000_000:  # 5MB
            print(f"[验证-{req_id}] 警告: 响应过大: {json_size} 字节")
            context["metadata"].setdefault("validation_warnings", []).append(
                f"响应过大: {json_size} 字节"
            )

    except Exception as e:
        print(f"[验证-{req_id}] 严重错误: 响应序列化失败: {str(e)}")
        context["metadata"].setdefault("validation_errors", []).append(str(e))
