To activate the image automation, run:

```
flux create secret git --url ssh://git@github.com/kingdonb/github-actions-demo ex7-writer -n ex7
```

(substituting your fork of the demo repo)
and copy the deploy key to GitHub, setting it as read-write.
