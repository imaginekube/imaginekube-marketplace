# Tekton for Imagine's Kubernetes Marketplace

Tekton is a Kubernetes native CI/CD pipeline.  See [manifest.yaml](manifest.yaml) for more details.

## Updating the application

Pull the pinned version of the installation yamls and assemble them into a unified `app.yaml`

```sh
make clean
make build
```

## Test the application

Requires that you the [the imaginekube cli utility installed](https://github.com/imaginekube/cli) and authentication setup correctly.  This will build out a small k3s cluster, deploy Tekton, then run a small job to verify the pipeline works as expected.  The cluster will be torn down upon successful completion.  If the build fails, the cluster will remain to assist in debugging the test failure.

```sh
make test
make test-keep  # Will test, but keep the cluster with app and tests running
```
