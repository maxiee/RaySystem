#!/bin/bash
# Run pytest with coverage and output results
pytest --cov=module --cov-report=term-missing --maxfail=3 --disable-warnings "$@"