#!/bin/bash

# assert sourcing only
[[ "${BASH_SOURCE[0]}" = "$0" ]] && echo "Usage: source $0" && exit 1

# check if docker is available
# if ! command -v docker > /dev/null;
# then
#   echo "Docker not found. Please install Docker first!"
#   return
# fi

# detect platform (amd64 only for now)
case "$OSTYPE" in
  darwin*) LOCAL_PLATFORM="darwin_amd64"  ;;
  linux*)  LOCAL_PLATFORM="linux_amd64"   ;;
  msys*)   LOCAL_PLATFORM="windows_amd64" ;;
  *) echo "Unsupported OS: $OSTYPE"; return ;;
esac

# project root path
if [ -n "$ZSH_VERSION" ]; then
  PROJECT_ROOT="$( cd "$( dirname "${(%):-%x}" )" >/dev/null && pwd )"
elif [ -n "$BASH_VERSION" ]; then
  PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
else
  PROJECT_ROOT="$( cd "$( dirname "$0" )" >/dev/null && pwd )"
fi

# use our binaries first
export PATH="$PROJECT_ROOT/bin/$LOCAL_PLATFORM:$PATH" && echo "PATH=$PATH"

# use our kubernetes and helm configuration
export KUBECONFIG="$PROJECT_ROOT/.kube/config"
export HELM_HOME="$PROJECT_ROOT/.helm"

echo "KUBECONFIG=$KUBECONFIG"
echo "HELM_HOME=$HELM_HOME"

# export basic paths to terraform
export TF_VAR_K8S_KUBE_CONFIG="$KUBECONFIG"
export TF_VAR_K8S_HELM_HOME="$HELM_HOME"

echo "TF_VAR_K8S_KUBE_CONFIG=$TF_VAR_K8S_KUBE_CONFIG"
echo "TF_VAR_K8S_HELM_HOME=$TF_VAR_K8S_HELM_HOME"
