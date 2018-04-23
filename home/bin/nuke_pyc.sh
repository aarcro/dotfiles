#!/usr/bin/env bash

find ./ -name \*pyc -ls -exec rm {} \;
find ./ -name __pycache__ -exec rmdir {} \;
