---
name: kubernetes
description: MUST be loaded before interacting with Kubernetes or using kubectl.
---

# Kubernetes

To preserve autonomous work, always place the `kubectl` subcommand before any flags or options. For multiword commands, place the complete subcommand sequence first. The permissions system match command prefixes such as `kubectl get` and `kubectl rollout status`; leading flags prevent a match and trigger manual approval.

Use `kubectl get pods --context my-context`, NOT `kubectl --context my-context get pods`.
