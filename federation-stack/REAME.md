# Helm chart for federation stack

[Istio Service Mesh Installation](https://istio.io/latest/docs/setup/getting-started/)

## Istio via ctl - needs CNI troubleshooting
istioctl install --set profile=demo -y     
kubectl label namespace default istio-injection=enabled
istioctl uninstall --purge -

## Istio via helm
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update
kubectl create namespace istio-system
helm install istio-base istio/base -n istio-system

helm install istiod istio/istiod -n istio-system \
  --set global.istioNamespace=istio-system \
  --set meshConfig.accessLogFile="/dev/stdout"

helm install istio-ingress istio/gateway -n istio-system

kubectl create namespace federation
kubectl label namespace federation istio-injection=enabled

## Kiali + Prometheus + Jaeger + Grafana


helm install prometheus istio/prometheus -n istio-system
helm install grafana istio/grafana -n istio-system
helm install jaeger istio/jaeger -n istio-system


## Install the federation stack
helm install federation-stack ./federation-stack --dry-run --debug
helm install federation-stack ./federation-stack
helm upgrade --install federation-stack ./federation-stack
helm uninstall federation-stack 

