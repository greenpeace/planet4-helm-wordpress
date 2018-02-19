# Planet 4 Helm charts for the Wordpress application OpenStack

Builds on [https://github.com/greenpeace/planet4-docker]() and [https://github.com/greenpeace/planet4-base]()

Charts stored in GS bucket gs://p4-helm-charts

---

## requirements.yaml
```
# add alias to remote repository
helm repo add p4-helm-charts https://p4-helm-charts.storage.googleapis.com
```
---
## updating remote repository
```
# Clone remote repository
gsutil rsync -d gs://p4-helm-charts planet4-helm-charts

# Craft new chart version
helm package .

# Move to local repo copy
mv p4-chart-name planet4-helm-charts

# Update local repository
helm repo index planet4-helm-charts --url https://p4-helm-charts.storage.googleapis.com

# Update GS bucket with new repository data
gsutil rsync -d planet4-helm-charts gs://p4-helm-charts
```
---

```
# idempotent install/updgrade command, overriding ingress hostname
helm upgrade --install --set "ingress.hosts[0]=test.planet4.minikube" p4-wordpress .
```
