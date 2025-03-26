# hybrid_property 的作用

`sqlalchemy.ext.hybrid.hybrid_property` 在 SQLAlchemy 中是一个非常强大的功能，它有以下几个关键作用：

1. **双重访问模式**：它允许你定义一个方法，这个方法既可以像普通的 Python 属性一样在 Python 对象上访问，也可以在数据库查询中使用。

2. **表达式转换**：当你在 Python 对象上访问 hybrid_property 时，它执行 Python 代码；当你在查询中使用它时，它会被转换为适当的 SQL 表达式。

3. **计算属性**：它可以根据模型的其他属性动态计算值，而不需要实际存储这个值在数据库中。

在你的 `Note` 模型中，`hybrid_property` 被用来创建一个虚拟的 `title` 属性：

```python
@hybrid_property
def title(self):
    """Get primary title or first title as fallback"""
    primary = next((t for t in self.note_titles if t.is_primary), None)
    if primary:
        return primary.title
    return self.note_titles[0].title if self.note_titles else ""
```

这个属性的作用是：
- 当你访问 `note.title` 时，它会检查关联的 `note_titles` 集合
- 首先尝试找到一个被标记为主要的标题（`is_primary=True`）
- 如果找到主要标题，返回它的内容
- 如果没有主要标题，则返回第一个标题（如果有的话）
- 如果没有任何标题，则返回空字符串

这样做的好处是，即使你移除了实际的 `title` 列，你的代码仍然可以像以前一样使用 `note.title` 这种写法，保持了 API 的一致性，同时支持了多标题的功能。