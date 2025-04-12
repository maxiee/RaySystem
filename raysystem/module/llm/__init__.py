# filepath: raysystem/module/llm/__init__.py
"""
LLM Module for interacting with OpenAI-compatible services.
Provides FastAPI endpoints and core service logic.
"""
from .api import router as llm_router

__all__ = ["llm_router"]

# Remember to include this router in your main FastAPI application:
#
# from fastapi import FastAPI
# from raysystem.module.llm import llm_router
#
# app = FastAPI()
# app.include_router(llm_router)
#
# # ... other app setup
