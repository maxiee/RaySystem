from module.llm.middlewares.context import ChatContext


# --- Example Middleware (define here or import from middleware.py) ---
async def logging_middleware(context: ChatContext):
    """简化的日志中间件，记录请求和响应信息。"""
    import uuid

    # 生成或获取请求ID
    req_id = context.get("metadata", {}).get("request_id")
    if not req_id:
        req_id = str(uuid.uuid4())[:8]
        if "metadata" not in context:
            context["metadata"] = {}
        context["metadata"]["request_id"] = req_id

    # 打印基本请求信息
    print(f"=== LLM请求 [{req_id}] ===")
    print(f"模型: {context.get('model')}")
    print(f"模型配置: {context.get('model_config_name')}")
    print(f"请求消息数量: {len(context.get('request_messages', []))}")

    # 打印响应信息
    if response := context.get("response_message"):
        print(f"=== LLM响应 [{req_id}] ===")
        print(f"响应角色: {response.role}")
        print(f"响应内容长度: {len(response.content)}")

        # 检查内容是否为空
        if not response.content:
            print(f"警告: 响应内容为空")

    # 打印错误信息
    if error := context.get("error"):
        print(f"=== LLM错误 [{req_id}] ===")
        print(f"错误类型: {type(error).__name__}")
        print(f"错误信息: {error}")

    # 打印使用统计
    if raw_response := context.get("raw_openai_response"):
        usage = raw_response.get("usage")
        if usage:
            print(f"使用统计: {usage}")

    print(f"=== LLM交互结束 [{req_id}] ===")
