from unittest.mock import patch
import pytest
import pytest_asyncio
from datetime import datetime
from sqlalchemy import select, func, delete, text
from sqlalchemy.orm import joinedload

from module.note.model import Note
from module.note.note import NoteManager, kNoteManager
from module.db.db import db_async_session
from tests.conftest import test_session


class TestNoteHierarchy:
    """Note层级管理功能的单元测试"""

    @pytest_asyncio.fixture
    async def note_manager(self):
        # 注意：不再传入会话，现在NoteManager不需要保存会话
        return NoteManager()
        
    @pytest.mark.asyncio
    async def test_create_note_with_parent(self, note_manager, test_session):
        """测试创建带有父节点的笔记"""
        # 先清理所有笔记
        async with test_session:
            await test_session.execute(delete(Note))
            await test_session.commit()
        
        # 1. 首先创建一个根节点笔记
        async with test_session:
            root_note = await note_manager.create_note(
                title="Root Note",
                content_appflowy="Root content",
                session=test_session
            )
        
        # 2. 然后创建一个子节点笔记，指定父节点
        async with test_session:
            child_note = await note_manager.create_note(
                title="Child Note",
                content_appflowy="Child content",
                parent_id=root_note.id,
                session=test_session
            )
        
            # 验证子节点的parent_id正确设置
            assert child_note.parent_id == root_note.id
        
        # 重新获取并验证根节点的children关系
        async with test_session:
            updated_root = await test_session.execute(
                select(Note).filter(Note.id == root_note.id).options(joinedload(Note.children))
            )
            updated_root = updated_root.unique().scalars().first()
            assert len(updated_root.children) == 1
            assert updated_root.children[0].id == child_note.id
        
    @pytest.mark.asyncio
    async def test_get_child_notes(self, note_manager, test_session):
        """测试获取子节点笔记列表"""
        # 先清理所有笔记
        async with test_session:
            await test_session.execute(delete(Note))
            await test_session.commit()
            
        # 创建一个根节点笔记
        async with test_session:
            root_note = await note_manager.create_note(
                title="Root Note for Children",
                content_appflowy="Root content",
                session=test_session
            )
        
        # 创建多个子节点笔记
        child_notes = []
        for i in range(3):
            async with test_session:
                child = await note_manager.create_note(
                    title=f"Child Note {i}",
                    content_appflowy=f"Child content {i}",
                    parent_id=root_note.id,
                    session=test_session
                )
                child_notes.append(child)
        
        # 获取root_note的所有子节点
        async with test_session:
            children = await note_manager.get_child_notes(
                root_note.id,
                session=test_session
            )
        
            # 验证子节点数量和内容
            assert len(children) == 3
            child_ids = [child.id for child in children]
            for child in child_notes:
                assert child.id in child_ids
            
    @pytest.mark.asyncio
    async def test_get_root_notes(self, note_manager, test_session):
        """测试获取根节点笔记列表"""
        # 清理旧的笔记数据
        async with test_session:
            await test_session.execute(delete(Note))
            await test_session.commit()
        
        # 创建几个根节点笔记
        root_notes = []
        for i in range(3):
            async with test_session:
                root = await note_manager.create_note(
                    title=f"Root Note {i}",
                    content_appflowy=f"Root content {i}",
                    session=test_session
                )
                root_notes.append(root)
        
        # 同时创建一个子节点，确保它不会出现在根节点列表中
        async with test_session:
            child = await note_manager.create_note(
                title="Child Note",
                content_appflowy="Child content",
                parent_id=root_notes[0].id,
                session=test_session
            )
        
        # 获取所有根节点（parent_id为None的笔记）
        async with test_session:
            roots = await note_manager.get_child_notes(
                None,
                session=test_session
            )
        
            # 验证根节点数量和内容
            assert len(roots) == 3
            root_ids = [root.id for root in roots]
            for root in root_notes:
                assert root.id in root_ids
            
            # 确保子节点不在根节点列表中
            assert child.id not in root_ids
        
    @pytest.mark.asyncio
    async def test_move_note(self, note_manager, test_session):
        """测试移动笔记到新的父节点"""
        # 先清理所有笔记
        async with test_session:
            await test_session.execute(delete(Note))
            await test_session.commit()
            
        # 创建一个层级结构：
        # root1
        #   - child1
        #     - grandchild
        # root2
        
        async with test_session:
            root1 = await note_manager.create_note(
                title="Root 1",
                content_appflowy="Root 1 content",
                session=test_session
            )
        
        async with test_session:
            root2 = await note_manager.create_note(
                title="Root 2",
                content_appflowy="Root 2 content",
                session=test_session
            )
        
        async with test_session:
            child1 = await note_manager.create_note(
                title="Child 1",
                content_appflowy="Child 1 content",
                parent_id=root1.id,
                session=test_session
            )
        
        async with test_session:
            grandchild = await note_manager.create_note(
                title="Grandchild",
                content_appflowy="Grandchild content",
                parent_id=child1.id,
                session=test_session
            )
        
        # Store IDs before moving
        child1_id = child1.id
        grandchild_id = grandchild.id
        
        # 现在移动 child1 到 root2 下
        async with test_session:
            moved_child = await note_manager.move_note(
                child1_id, 
                root2.id,
                session=test_session
            )
        
            # 验证移动是否成功
            assert moved_child.parent_id == root2.id
        
        # 获取并刷新节点状态
        async with test_session:
            updated_root1 = await test_session.execute(
                select(Note).filter(Note.id == root1.id).options(joinedload(Note.children))
            )
            updated_root1 = updated_root1.unique().scalars().first()
        
        async with test_session:
            updated_root2 = await test_session.execute(
                select(Note).filter(Note.id == root2.id).options(joinedload(Note.children))
            )
            updated_root2 = updated_root2.unique().scalars().first()
        
        # Get a fresh instance of grandchild
        async with test_session:
            updated_grandchild = await test_session.execute(
                select(Note).filter(Note.id == grandchild_id)
            )
            updated_grandchild = updated_grandchild.unique().scalars().first()
        
            # 检查层级关系是否正确更新
            assert len(updated_root1.children) == 0
            assert len(updated_root2.children) == 1
            assert updated_root2.children[0].id == child1_id
            
            # 确保孙节点的父节点关系不变
            assert updated_grandchild.parent_id == child1_id

    @pytest.mark.asyncio
    async def test_move_to_root(self, note_manager, test_session):
        """测试将笔记移动到根级别"""
        # 先清理所有笔记
        async with test_session:
            await test_session.execute(delete(Note))
            await test_session.commit()
            
        # 创建一个有父节点的笔记
        async with test_session:
            parent = await note_manager.create_note(
                title="Parent Note",
                content_appflowy="Parent content",
                session=test_session
            )
        
        async with test_session:
            child = await note_manager.create_note(
                title="Child Note",
                content_appflowy="Child content",
                parent_id=parent.id,
                session=test_session
            )
        
        # 将子节点移动到根级别
        async with test_session:
            moved_note = await note_manager.move_note(
                child.id, 
                None,
                session=test_session
            )
        
            # 验证移动是否成功
            assert moved_note.parent_id is None
        
        # 获取并验证关系更新
        async with test_session:
            updated_parent = await test_session.execute(
                select(Note).filter(Note.id == parent.id).options(joinedload(Note.children))
            )
            updated_parent = updated_parent.unique().scalars().first()
            assert len(updated_parent.children) == 0
        
        # 确认笔记现在是根节点
        async with test_session:
            roots = await note_manager.get_child_notes(None, session=test_session)
            root_ids = [root.id for root in roots]
            assert moved_note.id in root_ids
        
    @pytest.mark.asyncio
    async def test_circular_reference_prevention(self, note_manager, test_session):
        """测试防止循环引用"""
        # 先清理所有笔记
        async with test_session:
            await test_session.execute(delete(Note))
            await test_session.commit()
            
        # 创建一个层级结构：
        # root
        #   - child
        #     - grandchild
        
        async with test_session:
            root = await note_manager.create_note(
                title="Root Note",
                content_appflowy="Root content",
                session=test_session
            )
        
        async with test_session:
            child = await note_manager.create_note(
                title="Child Note",
                content_appflowy="Child content",
                parent_id=root.id,
                session=test_session
            )
        
        async with test_session:
            grandchild = await note_manager.create_note(
                title="Grandchild Note",
                content_appflowy="Grandchild content",
                parent_id=child.id,
                session=test_session
            )
        
        # 尝试将 root 移动为 grandchild 的子节点，这会创建循环引用
        with pytest.raises(ValueError, match="circular reference"):
            async with test_session:
                await note_manager.move_note(root.id, grandchild.id, session=test_session)
            
        # 验证结构未改变
        async with test_session:
            updated_root = await note_manager.get_note_by_id(root.id, session=test_session)
            assert updated_root.parent_id is None
        
    @pytest.mark.asyncio
    async def test_get_note_path(self, note_manager, test_session):
        """测试获取笔记路径"""
        # 先清理所有笔记
        async with test_session:
            await test_session.execute(delete(Note))
            await test_session.commit()
            
        # 创建一个层级结构：
        # root
        #   - child
        #     - grandchild
        
        async with test_session:
            root = await note_manager.create_note(
                title="Root Note",
                content_appflowy="Root content",
                session=test_session
            )
        
        async with test_session:
            child = await note_manager.create_note(
                title="Child Note",
                content_appflowy="Child content",
                parent_id=root.id,
                session=test_session
            )
        
        async with test_session:
            grandchild = await note_manager.create_note(
                title="Grandchild Note",
                content_appflowy="Grandchild content",
                parent_id=child.id,
                session=test_session
            )
        
        # 获取并验证从根节点到孙节点的完整路径
        async with test_session:
            path = await note_manager.get_note_path(grandchild.id, session=test_session)
        
            # 验证路径正确
            assert len(path) == 3
            assert path[0].id == root.id
            assert path[1].id == child.id
            assert path[2].id == grandchild.id
        
    @pytest.mark.asyncio
    async def test_delete_cascade(self, note_manager, test_session):
        """测试删除笔记时将子笔记重新分配给祖父级"""
        # 先清理所有笔记
        async with test_session:
            await test_session.execute(delete(Note))
            await test_session.commit()
            
        # 创建一个层级结构并保存ID
        async with test_session:
            root = await note_manager.create_note(
                title="Root to Delete",
                content_appflowy="Root content",
                session=test_session
            )
            root_id = root.id
        
        async with test_session:
            child1 = await note_manager.create_note(
                title="Child 1",
                content_appflowy="Child 1 content",
                parent_id=root_id,
                session=test_session
            )
            child1_id = child1.id
        
        async with test_session:
            child2 = await note_manager.create_note(
                title="Child 2",
                content_appflowy="Child 2 content",
                parent_id=root_id,
                session=test_session
            )
            child2_id = child2.id
        
        async with test_session:
            grandchild = await note_manager.create_note(
                title="Grandchild",
                content_appflowy="Grandchild content",
                parent_id=child1_id,
                session=test_session
            )
            grandchild_id = grandchild.id
        
        # 删除 child1 节点
        async with test_session:
            await note_manager.delete_note(child1_id, session=test_session)
        
        # 验证 child1 被删除
        async with test_session:
            deleted_note = await note_manager.get_note_by_id(child1_id, session=test_session)
            assert deleted_note is None
            
            # 验证 grandchild 仍然存在，但被重新指向 root
            updated_grandchild = await note_manager.get_note_by_id(grandchild_id, session=test_session)
            assert updated_grandchild is not None
            assert updated_grandchild.parent_id == root_id
        
        # 删除根节点
        async with test_session:
            await note_manager.delete_note(root_id, session=test_session)
        
        # 验证根节点被删除
        async with test_session:
            deleted_root = await note_manager.get_note_by_id(root_id, session=test_session)
            assert deleted_root is None
            
            # 验证 child2 和 grandchild 仍然存在，但现在是根节点
            remaining_notes = []
            remaining_notes.append(await note_manager.get_note_by_id(child2_id, session=test_session))
            remaining_notes.append(await note_manager.get_note_by_id(grandchild_id, session=test_session))
            assert len(remaining_notes) == 2
            
            for note in remaining_notes:
                assert note.parent_id is None  # 都应该成为根节点

    @pytest.mark.asyncio
    async def test_child_count(self, note_manager, test_session):
        """测试子节点计数功能"""
        # 首先清理所有笔记
        async with test_session:
            await test_session.execute(delete(Note))
            await test_session.commit()
        
        # 创建一个根节点
        async with test_session:
            root = await note_manager.create_note(
                title="Root for counting",
                content_appflowy="Root content",
                session=test_session
            )
        
        # 创建5个子节点
        for i in range(5):
            async with test_session:
                await note_manager.create_note(
                    title=f"Child {i}",
                    content_appflowy=f"Child content {i}",
                    parent_id=root.id,
                    session=test_session
                )
            
        # 检查子节点计数是否正确
        async with test_session:
            count = await note_manager.get_child_notes_count(root.id, session=test_session)
            assert count == 5
            
            # 同样检查根节点计数
            root_count = await note_manager.get_child_notes_count(None, session=test_session)
            assert root_count >= 1  # 至少有我们刚创建的那一个根节点