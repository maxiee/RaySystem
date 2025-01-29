## RaySystem

RaySystem 是 Maeiee 为自己量身打造的个人系统项目。这不是一个通用工具，而是围绕我的个人工作流设计的独特系统。它整合了我对工具哲学的深入思考，体现了强大的功能性和极高的定制化。

### 特色

1. **个人化的实践与哲学：** RaySystem 的核心价值在于，它是我探索技术、优化个人效率的实验场。

2. **强大的整合能力：** 使用强大的技术栈（Python、FastAPI、Emacs……）构建，极简而强大。

3. **深思熟虑的开发方式：** 每个模块都经过深思熟虑，确保系统的长期可维护性。

4. **极简与功能的平衡：** 坚持 KISS 原则，数据本地存储，尽可能减少对外部服务的依赖。

---

### 子项目

目前 RaySystem 采用 Client-Server 架构，主要包含以下子项目：

- `raysystem`：RaySystem Server 部分，包含所有核心功能实现。

- `raysystem_flutter`：RaySystem Client 部分，使用 Flutter 开发，支持桌面端及移动端。

- `emacs`：RaySystem Emacs Client，使用 Elisp 开发，未来计划与 Emacs 深度融合。

---

### 核心模块

RaySystem 由多个核心模块组成，实现位于 `raysystem` 的 `modules` 目录下：

| 模块名称 | 功能描述 |
| --- | --- |
|`browser`|基于 PlayWright 的浏览器访问模块。|
|`db`|数据库模块，使用 SQLAlchemy 进行 SQLite 数据库管理。|
|`early_sleeping`|AI 晚间日记助我早睡。|
|`fs`|文件系统模块，提供模块数据目录的管理。|
|`http`|基于 FastAPI 的 HTTP 服务模块。|
|`info`|资讯模块，基于站点、文章、标签等实现资讯管理。|
|`people`|人物模块，基于人物、关系等实现人物管理。|
|`storage`|存储模块，基于本地文件系统的对象存储。|
|`task_queue`|任务队列模块，支持任务的添加、删除、查询和异步执行。|
|`repl`|REPL 模块，支持异步 REPL 功能。|

---

### 公众号文章

我开通了一个公众号，来记录 RaySystem 的搭建过程，欢迎关注！目前已经发布的文章如下：

- [RaySystem Vol.001：探索趁手的个人系统](https://mp.weixin.qq.com/s/i4g6JZHS0JpKsbY-okEwrQ)
- [RaySystem Vol.002：uv、配置文件及首个 Data 模块](https://mp.weixin.qq.com/s/iFI98-KlLBkrQFuN7urjzg)
- [RaySystem Vol.003：Peewee 数据库，Info 资讯模块的 Models](https://mp.weixin.qq.com/s/XergeyemdAPJaDFYN_TDrA)
- [RaySystem Vol.004：本地对象存储模块 Storage](https://mp.weixin.qq.com/s/dvbUs3C2KB-JMgQ_-0rcmg)
- [RaySystem Vol.005：异步 REPL](https://mp.weixin.qq.com/s/RLlWqfgqUz3vtQjAmdxqZA)
- [RaySystem Vol.006：异步任务队列](https://mp.weixin.qq.com/s/FqS9L5nF2YIDk8GyGKaWPw)
- [RaySystem Vol.007：从 Peewee 到 SQLModel、aiosqlite 异步数据库](https://mp.weixin.qq.com/s/gllyvqRoIHRMUkrPm_cmsw)
- [RaySystem Vol.008：调研 Emacs Elfeed RSS 阅读器](https://mp.weixin.qq.com/s/fNKBIIj_fAC3kTlwi74xiw)
- [RaySystem Vol.009：Emacs Elfeed RSS 阅读器源码阅读](https://mp.weixin.qq.com/s/sJ3QlquzgyU_7fuUZBtoMA)
- [RaySystem Vol.010：Emacs Elfeed RSS 阅读器源码阅读（2）](https://mp.weixin.qq.com/s/B7EDGOBkYvsu8prHe1audQ)
- [RaySystem Vol.011：Emacs Elfeed RSS 阅读器源码阅读（3）](https://mp.weixin.qq.com/s/Mi_6nkKX58imIWeMWDzNhQ)
- [RaySystem Vol.012：创建自己的 Emacs Major Mode](https://mp.weixin.qq.com/s/_zXZOlYtcA0BaQ82rUQIXQ)
- [RaySystem Vol.013：引入 FastAPI 后端服务](https://mp.weixin.qq.com/s/NYNaUoNTxyJqEPoU8DYCYg)
- [RaySystem Vol.014：站点管理功能设计](https://mp.weixin.qq.com/s/SCNbIGJkw-nSm7tsfN0RXQ)
- [RaySystem Vol.015：AI晚间日记助我早睡](https://mp.weixin.qq.com/s/vrjed8pXBlkZv1GcM-gTeQ)
- [RaySystem Vol.016：由 SQLModel 切换至 SQLAlchemy](https://mp.weixin.qq.com/s/U0mV1OvVrbbokl4k1nlvbQ)
- [RaySystem Vol.017：引入 PlayWright 浏览器访问能力](https://mp.weixin.qq.com/s/86LDFRbYrQAuFbIrww19eA)
- [RaySystem Vol.018：People 模块及 Alembic SQLAlchemy 数据表迁移](https://mp.weixin.qq.com/s/mEZZ5SPqL-5PsgyzlShS4w)
- [RaySystem Vol.019：FastAPI 基于 OpenAPI 自动创建 Dart 调用](https://mp.weixin.qq.com/s/JBFfJ1qRkObR-0r3TrMLsQ)
- [RaySystem Vol.020：使用 Playwright + PageSnap 实现网页离线剪藏功能](https://mp.weixin.qq.com/s/DgIACDjd2opjET58k9W7GQ)
- [RaySystem Vol.021：MarkItDown 如何将 HTML 转 Markdown](https://mp.weixin.qq.com/s/Yaii8PEDt2pOm5PxwuDGzA)
- [RaySystem Vol.022：使用 ocrmac 集成 OCR 能力](https://mp.weixin.qq.com/s/i39vzNrEIcnpA-xE3Fvr4g)
- [RaySystem Vol.023：试用 Obsidian Clipper 网页剪藏插件](https://mp.weixin.qq.com/s/LcemfRsEvz01Ix4kAszaBw)
- [RaySystem Vol.024：Obsidian Database Folder + DataView 搭建网页剪藏大盘](https://mp.weixin.qq.com/s/O4_oLqpZAWZZpr4dBWWG6Q)
- [RaySystem Vol.025：Flutter 屏幕截图打通 OCR 能力](https://mp.weixin.qq.com/s/8VzHAsnKRaTttS13ZwXYcA)
- [RaySystem Vol.026：修理挂掉的 Arch Linux](https://mp.weixin.qq.com/s/e9a-qwc5hu2XVltbZg0skQ)
- [RaySystem Vol.027：本地运行 DeepSeek R1 Distill Qwen 32B 模型](https://mp.weixin.qq.com/s/ZGq4M31eb8_sUgZN8iW9Dg)
- [RaySystem Vol.028：我是这样借助 AI 学 Rust 与算法的](https://mp.weixin.qq.com/s/HwkQfH9bAHBMNJKZtaHEEA)

---

### 立即支持！

RaySystem 是我个人对工具和工作流探索的精心结晶，如果你对系统设计、个人效率提升或者工具哲学感兴趣，欢迎 Star 这个项目。

也欢迎关注我的公众号，点赞支持！