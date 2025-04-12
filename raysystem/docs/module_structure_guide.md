# RaySystem 标准化模块结构指南

本文档提供了 RaySystem 模块的标准化结构指南，用于指导现有模块的重构和新模块的开发。通过统一模块结构，可以提高代码可维护性、可读性和开发效率。

## 目录

1. [模块基本结构](#模块基本结构)
2. [文件命名和职责](#文件命名和职责)
3. [模块初始化](#模块初始化)
4. [数据库模型](#数据库模型)
5. [API 端点](#api-端点)
6. [Schema 定义](#schema-定义)
7. [工具函数](#工具函数)
8. [事件处理](#事件处理)
9. [配置和常量](#配置和常量)
10. [模块文档](#模块文档)
11. [实际案例](#实际案例)
12. [总结与建议](#总结与建议)

## 模块基本结构

每个模块应遵循以下基本结构：

```
module/
├── __init__.py         # 模块初始化和公开接口
├── model.py            # 数据库模型 (SQLAlchemy)
├── core.py             # 核心功能实现（模块主类和功能）
├── api.py              # API 端点定义 (FastAPI)
├── schemas.py          # Pydantic 模型定义
├── utils.py            # 工具函数
├── events.py           # 事件处理（可选）
└── README.md           # 模块文档
```

## 文件命名和职责

### `__init__.py`

- 导入和重新导出模块的公开接口
- 提供一个 `init()` 函数以初始化整个模块
- 对其他模块隐藏内部实现细节

```python
from module.example.core import init_example_core, ExampleManager
from module.example.api import init_example_api
from module.example.events import init_example_events

# 全局实例（如果适用）
kExampleManager = ExampleManager()

def init():
    """初始化整个模块"""
    init_example_core()
    init_example_api()
    init_example_events()
    print("Example module initialized")
```

### `model.py`

- 定义 SQLAlchemy ORM 模型
- 只包含数据结构定义和关系，不包含业务逻辑

```python
from sqlalchemy import Integer, String, ForeignKey, DateTime, Boolean
from sqlalchemy.orm import Mapped, mapped_column, relationship
from module.db.base import Base

class ExampleModel(Base):
    """示例模型"""
    __tablename__ = "example"
    
    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    name: Mapped[str] = mapped_column(String, index=True)
    # 其他字段...
```

### `core.py`

- 包含核心业务逻辑
- 定义模块主类和主要功能
- 不直接处理 HTTP 请求

```python
from typing import List, Optional
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from module.db.db import db_async_session
from module.example.model import ExampleModel

class ExampleManager:
    """管理示例资源的核心类"""
    
    async def create_item(self, name: str, session: Optional[AsyncSession] = None) -> ExampleModel:
        """创建新条目"""
        if session is None:
            async with db_async_session() as session:
                return await self._create_item(name, session)
        else:
            return await self._create_item(name, session)
    
    async def _create_item(self, name: str, session: AsyncSession) -> ExampleModel:
        item = ExampleModel(name=name)
        session.add(item)
        await session.commit()
        await session.refresh(item)
        return item
    
    # 其他方法...

# 全局管理器实例
kExampleManager = ExampleManager()

def init_example_core():
    """初始化核心功能"""
    print("Example core initialized")
```

### `api.py`

- 定义 FastAPI 路由和端点
- 处理 HTTP 请求和响应
- 调用 core.py 中的业务逻辑

```python
from fastapi import Depends, HTTPException, Query
from sqlalchemy.ext.asyncio import AsyncSession
from module.http.http import APP
from module.db.db import get_db_session
from module.example.core import kExampleManager
from module.example.schemas import ExampleResponse, ExampleCreate

@APP.post("/examples/", response_model=ExampleResponse, tags=["examples"])
async def create_example(
    example: ExampleCreate,
    session: AsyncSession = Depends(get_db_session)
):
    """创建新的示例项目"""
    result = await kExampleManager.create_item(example.name, session)
    return result

# 其他 API 端点...

def init_example_api():
    """初始化 API 端点"""
    print("Example API initialized")
```

### `schemas.py`

- 定义 Pydantic 模型用于数据验证和序列化
- 包括请求模型、响应模型和中间模型

```python
from typing import Optional, List
from pydantic import BaseModel, ConfigDict
from datetime import datetime

class ExampleBase(BaseModel):
    """基础示例模型"""
    name: str

class ExampleCreate(ExampleBase):
    """创建示例的请求模型"""
    pass

class ExampleUpdate(BaseModel):
    """更新示例的请求模型"""
    name: Optional[str] = None

class ExampleResponse(ExampleBase):
    """示例响应模型"""
    id: int
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)

class ExampleList(BaseModel):
    """示例列表响应模型"""
    items: List[ExampleResponse]
    total: int
    has_more: bool

    model_config = ConfigDict(from_attributes=True)
```

### `utils.py`

- 提供辅助函数和工具
- 不包含业务逻辑

```python
def format_example_name(name: str) -> str:
    """格式化示例名称"""
    return name.strip().lower()

# 其他工具函数...
```

### `events.py` (可选)

- 定义事件监听器和处理程序
- 处理模型事件（例如，SQLAlchemy 事件）

```python
from sqlalchemy import event
from module.example.model import ExampleModel

@event.listens_for(ExampleModel, 'after_insert')
def handle_example_created(mapper, connection, target):
    """处理示例创建后事件"""
    # 事件处理逻辑...

def init_example_events():
    """初始化事件处理程序"""
    print("Example events initialized")
```

## 模块初始化

模块初始化应当遵循以下模式：

1. 每个功能文件提供自己的初始化函数，如 `init_example_core()`
2. 主 `__init__.py` 提供一个统一的 `init()` 函数调用所有子初始化函数
3. 初始化顺序应该是：
   - 核心功能 (core)
   - API (api)
   - 事件处理 (events)

## 数据库模型

- 所有模型应继承自 `module.db.base.Base`
- 使用 SQLAlchemy 2.0 风格的类型注解
- 为每个字段添加注释说明其用途
- 使用合适的关系配置（例如，cascade 删除规则）

## API 端点

- 使用 FastAPI 装饰器定义路由
- 为每个端点添加 `tags` 以按功能分组
- 使用 Pydantic 模型进行请求和响应的验证
- 在 API 函数中添加详细的文档字符串
- 遵循 REST 最佳实践：
  - GET：获取资源
  - POST：创建资源
  - PUT：完整更新资源
  - PATCH：部分更新资源
  - DELETE：删除资源

## Schema 定义

- 为每个资源类型定义以下 Pydantic 模型：
  - `Base`：基础字段
  - `Create`：创建时需要的字段
  - `Update`：更新时需要的字段（通常字段都是可选的）
  - `Response`：API 响应格式
  - `List`：列表响应格式

## 工具函数

- 工具函数应该是纯函数
- 每个函数应该只完成一个明确的任务
- 添加详细的文档字符串解释函数的用途和参数

## 事件处理

- 使用 SQLAlchemy 事件系统处理数据库事件
- 为每个事件处理程序添加文档字符串
- 保持事件处理程序的轻量和专注

## 配置和常量

- 模块特定的常量应定义在 `module.base.constants` 中
- 常量名应当全大写，并以模块名作为前缀

```python
# module/base/constants.py
EXAMPLE_MODULE_NAME = "example"
EXAMPLE_DEFAULT_LIMIT = 50
```

## 模块文档

每个模块都应该有一个 README.md 文件，包含以下内容：

- 模块的目的和功能
- 主要类和函数的概述
- 示例代码
- 依赖关系
- 配置选项（如果有）

## 实际案例

以下是根据现有代码库中的 `note` 模块重构的示例：

### 原始结构

```
note/
├── __init__.py
├── api.py
├── events.py
├── model.py
├── note.py
└── schema.py
```

### 标准化后的结构

```
note/
├── __init__.py     # 提供统一初始化入口
├── api.py          # API 端点定义
├── core.py         # 核心功能（原 note.py 重命名）
├── events.py       # 事件处理
├── model.py        # 数据库模型
├── schemas.py      # Pydantic 模型（原 schema.py 重命名）
└── README.md       # 新增模块文档
```

### __init__.py

```python
from module.note.core import init_note, kNoteManager
from module.note.api import init_note_api
from module.note.events import init_note_events

def init():
    """Initialize the note module"""
    init_note()
    init_note_api()
    init_note_events()
```

## 总结与建议

1. **一致性**：保持整个代码库中模块结构的一致性
2. **职责分离**：每个文件应该有明确定义的职责
3. **命名规范**：使用一致的命名约定
4. **文档**：详细记录每个模块的功能和用法
5. **适度重构**：逐步将现有模块调整为符合标准化结构

遵循这些指导原则，将使 RaySystem 更加容易维护和扩展，同时为新模块的开发提供清晰的结构和最佳实践。

## 渐进式重构计划

为了避免一次性进行大规模重构带来的风险，建议采用以下渐进式重构策略：

1. 首先为新模块应用标准化结构
2. 在修改现有模块功能时，同时进行结构调整
3. 优先重构核心模块和频繁变化的模块
4. 在重构过程中保持充分的测试覆盖

通过这种方式，可以在不破坏现有功能的同时，逐步提高代码库的一致性和可维护性。