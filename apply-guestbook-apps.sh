#!/bin/bash

# A simple Bash script to generate ArgoCD Application YAMLs.

for i in {0..99}; do
  cat << EOF | kubectl apply -f -
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: guestbook-$i
  namespace: argocd
  labels:
    app: guestbook
spec:
  destination:
    namespace: guestbook-$i
    server: https://kubernetes.default.svc
  project: default
  source:
    path: guestbook
    repoURL: https://github.com/Julian-Chu/argocd-memory-optimization-test.git
    targetRevision: HEAD
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
EOF
  echo "Generated guestbook-$i.yaml"
done
