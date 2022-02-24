### 

[TODO][FIXME] - link to detailed information about this snippet:

```yaml
kind: HelmRelease
metadata:
  name: myrelease
  namespace: flux-system
spec:
  chart:
    spec:
      reconcileStrategy: Revision  # <-- The revision is updated on every helm package, including changes to values.yaml
```

Without this setting, you will observe "interesting" behavior around when `HelmChart` resources are generated.
