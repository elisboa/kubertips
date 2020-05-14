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

#### Creating a deploy and a service without a yaml

`kubectl run -n NAMESPACE DEPLOY-NAME --image=IMAGE_REGISTRY/IMAGE_NAME --port=9090 --expose=true`

This will create a deploy and a service using `ClusterIP`

You can edit it later by doing:

`kubectl edit deploy DEPLOY-NAME -n NAMESPACE` to edit the deploy entry
and
`kubectl edit service DEPLOY-NAME -n NAMESPACE` to edit the service entry

Note that in some cases the ClusterIP won't work, so you must use another one like NodePort if you want external access to your pod.

---

#### Saving all deploys separated by namespace


```
for namespace in $(kubectl get namespaces | grep -v ^NAME | awk '{print $1}')
do
    echo -e "Checking namespace $namespace"
    if mkdir -pv $namespace
    then
        for deploy in $(kubectl -n $namespace get deploy | grep -v ^NAME | awk '{print $1}')
        do
            echo -ne "Saving deploy $deploy on ${PWD}/${namespace}/deploy-${deploy}.yaml file: 
            if kubectl -n $namespace get deploy $deploy -o yaml > ${namespace}/deploy-${deploy}.yaml
            then
                echo SUCCESS
            else
                echo FAILED
        done
    else
        echo "Failed to create or access ${PWD}/${namespace} directory
        exit 1
    fi
done
```


If you rather do it in one line
```
for namespace in $(kubectl get namespaces | grep -v NAME | cut -d\  -f1) ; do echo Checking namespace $namespace ; mkdir -pv $namespace ; for deploy in $(kubectl -n $namespace get deploy | grep -v NAME | cut -d\  -f1) ; do echo Saving deploy $deploy on ${PWD}/${namespace}/deploy-${deploy}.yaml ; kubectl -n $namespace get deploy $deploy -o yaml > ${namespace}/${deploy}.yaml ; done ; done # save deploys separated by namespace
```

