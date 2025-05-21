# Helm chart for federation stack

[Istio Service Mesh Installation](https://istio.io/latest/docs/setup/getting-started/)



## GKE VMs verification
gcloud compute instances list --filter="name:gke-cloud-federation" --format="table(name, tags.items)"



## Cluster Operational View
git clone  https://github.com/schoolofdevops/kube-ops-view
kubectl apply -f kube-ops-view/deploy/



## Istio via ctl
./bin/istioctl install \
  --set profile=demo \
  --set components.cni.enabled=false

kubectl label namespace default istio-injection=enabled

./bin/istioctl uninstall --purge -y



## Kiali 
https://kiali.io/docs/installation/quick-start/
<!-- from istioctl directory -->
kubectl apply -f samples/addons/kiali.yaml
./bin/istioctl dashboard kiali




## Creating dedicated namespace
kubectl create namespace federation
kubectl label namespace federation istio-injection=enabled
kubectl label namespace federation app.kubernetes.io/managed-by=Helm --overwrite
kubectl annotate namespace federation meta.helm.sh/release-name=federation-stack --overwrite
kubectl annotate namespace federation meta.helm.sh/release-namespace=federation --overwrite

kubectl delete namespace federation 


## Install the federation stack
helm install federation-stack ./federation-stack --namespace federation --dry-run --debug
helm install federation-stack ./federation-stack --namespace federation
helm upgrade federation-stack ./federation-stack --namespace federation

helm uninstall federation-stack --namespace federation



# Troubleshooting

kubectl get events --namespace=default
kubectl get pods --all-namespaces 