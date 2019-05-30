helm delete letsencrypt --purge

helm delete cert-manager --purge

kubectl delete -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.8/deploy/manifests/00-crds.yaml

kubectl delete namespace cert-manager

