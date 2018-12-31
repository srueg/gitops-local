#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
#set -o xtrace

function apply {
    kubectl "$@" --save-config --dry-run --output yaml | kubectl apply -f -
}

export TILLER_NAMESPACE=tiller
export FLUX_FORWARD_NAMESPACE=flux
export GIT_REPO='git@github.com:srueg/gitops-local.git'

apply create namespace $TILLER_NAMESPACE
apply create clusterrolebinding tiller-admin --clusterrole cluster-admin --serviceaccount $TILLER_NAMESPACE:default

helm init --wait --tiller-namespace $TILLER_NAMESPACE

kubectl apply -f https://raw.githubusercontent.com/weaveworks/flux/master/deploy-helm/flux-helm-release-crd.yaml

helm repo add weaveworks https://weaveworks.github.io/flux

helm install --name flux \
  --set helmOperator.create=true \
  --set helmOperator.createCRD=false \
  --set helmOperator.tillerNamespace=$TILLER_NAMESPACE \
  --set git.url=$GIT_REPO \
  --namespace $FLUX_FORWARD_NAMESPACE \
  --wait \
  weaveworks/flux

if hash fluxctl 2>/dev/null; then
    fluxctl identity
fi
