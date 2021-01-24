#!/bin/bash

# see https://explainshell.com/explain?cmd=set+-euxo%20pipefail
set -uexo pipefail

# if triggered by a timer, there will be no build user
BUILD_USER_ID=${BUILD_USER_ID:-jenkins}

# sometimes we get user id as email address
BUILD_USER_ID_CLEAN=(${BUILD_USER_ID//@/ })

CURRENT_TIME=$(TZ=UTC date +"%Y-%m-%dT%H:%M:%SZ")

kubectl create namespace $NAMESPACE
kubectl annotate namespace $NAMESPACE webtech/deployed_by=$BUILD_USER_ID_CLEAN
kubectl annotate namespace $NAMESPACE webtech/build_url=$BUILD_URL
kubectl annotate namespace $NAMESPACE webtech/created_time=$CURRENT_TIME
