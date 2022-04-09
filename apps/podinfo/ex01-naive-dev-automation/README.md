To activate the image automation, run:

```
flux create secret git --url ssh://git@github.com/kingdonb/github-actions-demo flux-system -n ex1
```

(substituting your fork of the demo repo)
and copy the deploy key to GitHub, setting it as read-write.
