"""[people] people add more names

Revision ID: 4ff507e26b13
Revises: 
Create Date: 2025-01-08 18:58:18.475741

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '4ff507e26b13'
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('people', sa.Column('name4', sa.String(), nullable=True))
    op.add_column('people', sa.Column('name5', sa.String(), nullable=True))
    op.create_index(op.f('ix_people_name4'), 'people', ['name4'], unique=False)
    op.create_index(op.f('ix_people_name5'), 'people', ['name5'], unique=False)
    # ### end Alembic commands ###


def downgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_index(op.f('ix_people_name5'), table_name='people')
    op.drop_index(op.f('ix_people_name4'), table_name='people')
    op.drop_column('people', 'name5')
    op.drop_column('people', 'name4')
    # ### end Alembic commands ###
