## RaySystem

RaySystem 是我为自己打造的一款个人系统。个人系统指一套软件工具链，这些软件既包含现有成品软件，也包含我们从头开发的软件，它们协同工作，共同组成一个整体。通过个人系统，我可以更高效地完成工作，更好地管理生活，更好地学习和成长。

RaySystem 本身是一个 Python 项目，使用 `uv` 进行管理。RaySystem 由一系列功能模块组成，每个模块负责一种功能。RaySystem 是一个持久化运行的程序，当运行后，它会调度各个模块，完成各种任务。

整个项目以迭代的方式进行开发，目前具备的模块（module）包括：

- `task_queue`：任务队列模块，用于管理任务队列，支持任务的添加、删除、查询等操作。
- `storage`：一个基于本地文件系统的对象存储模块，支持文件的添加、删除、查询等操作。

---

## 搭建过程

我开通了一个公众号，来记录 RaySystem 的搭建过程，欢迎关注！目前已经发布的文章如下：

- [RaySystem Vol.001：探索趁手的个人系统](https://mp.weixin.qq.com/s/i4g6JZHS0JpKsbY-okEwrQ)
- [RaySystem Vol.002：uv、配置文件及首个 Data 模块](https://mp.weixin.qq.com/s/iFI98-KlLBkrQFuN7urjzg)
- [RaySystem Vol.003：Peewee 数据库，Info 资讯模块的 Models](https://mp.weixin.qq.com/s/XergeyemdAPJaDFYN_TDrA)
- [RaySystem Vol.004：本地对象存储模块 Storage](https://mp.weixin.qq.com/s/dvbUs3C2KB-JMgQ_-0rcmg)
- [RaySystem Vol.005：异步 REPL](https://mp.weixin.qq.com/s/RLlWqfgqUz3vtQjAmdxqZA)
- [RaySystem Vol.006：异步任务队列](https://mp.weixin.qq.com/s/FqS9L5nF2YIDk8GyGKaWPw)
