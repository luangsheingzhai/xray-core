#!/bin/bash

# 获取标准格式的提交时间
RAW_DATE=$(git log -1 --format=%ci)
echo "原始提交时间: $RAW_DATE"

# 检测操作系统类型并相应处理
OS_TYPE=$(uname)
if [[ "$OS_TYPE" == "Darwin" ]]; then
    # macOS 处理方式 - 两步转换
    # 1. 首先将时间转换为时间戳
    TIMESTAMP=$(date -j -f "%Y-%m-%d %H:%M:%S %z" "$RAW_DATE" "+%s")
    # 2. 然后将时间戳转换为UTC格式的时间字符串
    COMMIT_TIMESTAMP=$(date -j -u -r $TIMESTAMP "+%Y%m%d%H%M%S")
else
    # Linux 处理方式 - 直接转换
    COMMIT_TIMESTAMP=$(date -d "$RAW_DATE" -u +"%Y%m%d%H%M%S")
fi

echo "提交UTC时间戳: $COMMIT_TIMESTAMP"

# 获取Git提交的哈希值
COMMIT_HASH=$(git rev-parse --short=12 HEAD)
echo "提交哈希值: $COMMIT_HASH"

# 组装成伪版本号
PSEUDO_VERSION="v1.250803.1-0.${COMMIT_TIMESTAMP}-${COMMIT_HASH}"
echo "完整伪版本号: $PSEUDO_VERSION"

echo ""
echo "用于go.mod的replace指令:"
echo "replace github.com/原始仓库/模块 => github.com/luangsheingzhai/Xray-core $PSEUDO_VERSION"