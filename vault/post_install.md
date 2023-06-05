## HashiCorp Vault

### Security Warning

By default, the chart runs in standalone mode. This mode uses a single Vault server with a file storage backend. This is a less secure and less resilient installation that is NOT appropriate for a production setup. It is highly recommended to use a [properly secured Kubernetes cluster](https://kubernetes.io/docs/tasks/administer-cluster/securing-a-cluster/), [learn the available configuration options](https://www.vaultproject.io/docs/platform/k8s/helm/configuration), and read the [production deployment checklist](https://www.vaultproject.io/docs/platform/k8s/helm/run#architecture).

Source: https://www.vaultproject.io/docs/platform/k8s/helm#using-the-helm-chart

### Post installation configuration

After installing HashiCorp Vault on your [Imagine K3S Cluster](https://www.imaginekube.com/) you need to [initialize the Vault server](https://www.vaultproject.io/docs/commands/operator/init).
This generates all needed data and prints out the [unseal keys](https://www.vaultproject.io/docs/concepts/seal)
and the [root token](https://www.vaultproject.io/docs/concepts/tokens#root-tokens).

```sh
# Initialize the Vault operator.
# ATTENTION: Write down the "Unseal Keys" and "Initial Root Token".
kubectl --namespace vault exec --tty --stdin vault-0 -- vault operator init

# Unseal the cluster.
# Repeat this step 3 times each time with a different unseal key.
kubectl --namespace vault exec --tty --stdin vault-0 -- vault operator unseal
```

Additionally you have to make sure that you have the [Vault binary installed locally](https://www.vaultproject.io/downloads) on your workstation.

#### High Availability with Raft

Please refer to the official documentation:
https://developer.hashicorp.com/vault/docs/platform/k8s/helm/examples/ha-with-raft

### Accessing the UI Frontend

Vault comes with a nice UI where you can do most of the management instead of using the terminal.
To access it you need to install a Kubernetes Ingress Controller like [Nginx](https://www.imaginekube.com/marketplace/Nginx) or [HAProxy](https://www.imaginekube.com/learn/install-haproxy-as-ingress-in-imaginekube-kubernetes).

Next create the Kubernetes Manifest for the Ingress resource and apply it.
Here an example for [Nginx](https://www.imaginekube.com/marketplace/Nginx):

```sh
cat <<EOF | kubectl -n vault apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: vault-ingress
  annotations:
    kubernetes.io/ingress.class: nginx
spec:
  rules:
  - host: vault.<MY_IMAGINE_CLUSTER_DNS_NAME>
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
             name: vault-internal
             port:
               number: 8200
EOF
```
