# Planet 4 Wordpress Helm Chart

[![Planet4](https://cdn-images-1.medium.com/letterbox/300/36/50/50/1*XcutrEHk0HYv-spjnOej2w.png?source=logoAvatar-ec5f4e3b2e43---fded7925f62)](https://medium.com/planet4)

Builds on [https://github.com/greenpeace/planet4-docker]() and [https://github.com/greenpeace/planet4-base]()

Charts stored in GS bucket gs://p4-helm-charts

---

## Quickstart

```
# Add alias to remote repository
helm repo add p4-helm-charts https://p4-helm-charts.storage.googleapis.com

# Install/upgrade command, with custom values
helm upgrade --install p4-gpi \
  -f values-local.yaml \
  --set wp.stateless.serviceAccountKey="$(cat secrets/cloudstorage-service-account.json | base64 -w 0)" \
  --set sqlproxy.serviceAccountKey="$(cat secrets/cloudsql-service-account.json | base64 -w 0)" \
  p4-helm-charts/wordpress

```

---

## Updating repository with new chart version

```
make
```

The simple command `make` will:
-   Create a directory (../planet4-helm-charts by default) to store chart bucket contents
-   Pull contents of P4 Helm GCS bucket
-   Package the current directory as a new chart version
-   Move the packaged chart to the local chart directory
-   Update the index
-   Synchronise local chart directory with GCS bucket contents

For managing repository updates it is strongly recommended to use https://github.com/viglesiasce/helm-gcs
