# ArgoCD memory optimization test

## Results

[result](./results/argocd-memory-optimization-test.md)

## install ArgoCD 
helm upgrade --install argocd ./argocd -nargocd --atomic

## make argocd self-host

apply the following manifest

```shell
kubectl apply -f - <<EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: argocd
  namespace: argocd
spec:
  destination:
    namespace: argocd
    server: https://kubernetes.default.svc
  project: default
  source:
    path: argocd
    repoURL: https://github.com/Julian-Chu/argocd-memory-optimization-test.git
    targetRevision: HEAD
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
EOF```

## how to sync argocd changes
we don't use app of apps here, manually sync is required.

### port-forward argocd server
- kubectl port-forward svc/argocd-server -n argocd 8080:443
### authentication
- argocd admin initial-password -n argocd  // get admin password 
- argocd login localhost:8080

### sync argocd app via cli
- argocd app sync argocd

## test plan

### deploy guestbook apps
- ./apply-guestbook-apps.sh
### trigger guestbook apps sync
- ./sync-guestbook-apps.sh

### environment

environment:
- guestbook app * 41 (0-40)
- sync all them 3 times in one hour


| Test case |         | 
| --------- | ------- |
|    1      |         |
|    2      |         |
|    3      |         |
