# My Kubernetes basic toolkit

Basically it's a quick start approach to new Kubernetes clusters

---

#### Basic commands

`kubectl get nodes -o wide # list all nodes`

`kubectl get pods -o wide --all-namespaces # list all pods`

`kubectl get deploys -o wide --all-namespaces # list all deploys`

---

#### Dashboard

1. `kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta4/aio/deploy/recommended.yaml # deploy dashboard`
2. `kubectl apply -f ServiceAccount-kubernetes-dashboard-admin-user.yaml # create service account dashboard admin user`
3. `kubectl apply -f ClusterRoleBinding-dashboard-admin-user.yaml # create cluster role binding`

---
