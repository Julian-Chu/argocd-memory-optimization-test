# Makefile for ArgoCD Memory Optimization Test

KUBECONFIG ?= $(HOME)/.kube/config
export KUBECONFIG

KUBECTL = KUBECONFIG=$(KUBECONFIG) kubectl

.DEFAULT_GOAL := help

define check_context
	@echo "Current Kubernetes context: $($(KUBECTL) config current-context 2>&1)"
endef


.PHONY: install-argocd apply-guestbook-apps sync-guestbook-apps delete-guestbook-apps clean get-argocd-password port-forward-argocd

install-argocd: ## Install ArgoCD
	@$(call check_context)
	@echo "Installing ArgoCD..."
	@helm install argocd ./argocd -n argocd --create-namespace

apply-guestbook-apps: ## Apply guestbook applications
	@$(call check_context)
	@echo "Applying guestbook apps..."
	@./apply-guestbook-apps.sh

sync-guestbook-apps: ## Sync guestbook applications
	@$(call check_context)
	@echo "Syncing guestbook apps..."
	@./sync-guestbook-apps.sh

delete-guestbook-apps: ## Delete guestbook applications
	@$(call check_context)
	@echo "Deleting guestbook apps..."
	for i in $$(seq 0 99); do \
		$(KUBECTL) delete application guestbook-$$i -n argocd; \
	done

get-argocd-password: ## Get ArgoCD initial admin password
	@echo "Getting ArgoCD initial admin password..."
	@argocd admin initial-password -n argocd

port-forward-argocd: ## Port-forward to ArgoCD server
	@$(call check_context)
	@echo "Forwarding port 8080 to ArgoCD server (blocking command)..."
	@$(KUBECTL) port-forward svc/argocd-server -n argocd 8080:443

help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-25s %s\n", $1, $2}'


context:
	kubectl config current-context
