# GitOps Config
K8s resources to use with [weaveworks Flux](https://github.com/weaveworks/flux)


## Bootstrap New Cluster
```bash
helm repo add weaveworks https://weaveworks.github.io/flux
helm install --name flux \
  --set helmOperator.create=true \
  --set helmOperator.tillerNamespace=tiller \
  --set git.url=git@github.com:srueg/gitops-local.git \
  --namespace flux \
  weaveworks/flux
```
