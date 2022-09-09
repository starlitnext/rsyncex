#!/bin/bash

# 修改ssh的port
SSH_PARAM="-e 'ssh -p 32200'"
# 上传代码的参数
UPLOAD_PARAM="-av --delete --exclude='client' --exclude='*.pyc' --exclude='*.pyo'"
# 下载代码的参数
DOWNLOAD_PARAM="-av"
