#!/bin/sh

domain="$CLUSTER_ID.k8s.imaginekube.com"
email="$EMAIL"
edition=$EDITION

helm repo add gitlab https://charts.gitlab.io/
helm repo update

kubectl create namespace gitlab --dry-run=client -o yaml | kubectl apply -f - 

echo 'waiting for 30s for the components to get started'
#Wait for the Cert Manager deployment to be done.
kubectl wait --for=condition=available --timeout=300s deployment/cert-manager-webhook  -n cert-manager

helm upgrade --install gitlab gitlab/gitlab --namespace gitlab --set global.edition="$edition" --set global.hosts.domain="$domain" --set certmanager-issuer.email="$email" --timeout 600s --version 5.4.0 -f https://raw.githubusercontent.com/imaginekube/kubernetes-marketplace/master/gitlab/config.yaml 

