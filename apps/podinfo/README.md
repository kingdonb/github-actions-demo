### Welcome to the GitHub Actions demo

These are the Flux automation examples. Also see the GitHub Actions examples, linked below.

## Flux Update Automation

#### podinfo examples

### `ImageUpdateAutomation` Examples

The first three examples all use Flux's `ImageUpdateAutomation` which I have called the naive automation here, because it naively depends on that no
manifest change is required in the new release.

##### About Ingresses

I have added an `Ingress` for each frontend service with a bogus hostname.

Add these to your `/etc/hosts` to access each podinfo:

```
10.17.12.124 ex1-podinfo ex2-podinfo ex3-podinfo ex4-podinfo ex5-podinfo
```

That's my IP address - Use your own IP address, or whatever you see in this output when you run:

```
$ kubectl -n kube-system get svc traefik
NAME      TYPE           CLUSTER-IP     EXTERNAL-IP    PORT(S)                      AGE
traefik   LoadBalancer   10.43.182.95   10.17.12.124   80:31146/TCP,443:32286/TCP   139m
                                        ^^^^^^^^^^^^
```

(If you're not running k3s or some cloud provider, you might need to install Traefik on your own!)

##### About the Examples

These are framed as three separate examples, and they can each be adopted or rejected separately, but as the demonstration will
show they are all linked into one example.  This is an easy and complete approach to environment promotion that is straightforward
and no-frills. It is driven with familiar Git branching and tagging that should be easy for anyone already familiar with Flux to
follow.

* `ex01-naive-dev-automation/` -
  [link](https://github.com/kingdonb/github-actions-demo/tree/main/apps/podinfo/ex01-naive-dev-automation#readme)
In the dev environment, the latest image is deployed, based on a timestamp.
This is an appropriate config for rapid iteration and might be adapted for
production.

* `ex02-naive-test-semver-automation/` -
  [link](https://github.com/kingdonb/github-actions-demo/tree/main/apps/podinfo/ex02-naive-test-semver-automation#readme)
In this example, the latest release or pre-release candidate image is deployed,
based on a semver expression. Consider using this approach in a staging
environment.

* `ex03-naive-prod-semver-automation/` -
  [link](https://github.com/kingdonb/github-actions-demo/tree/main/apps/podinfo/ex03-naive-prod-semver-automation#readme)
In this example, the latest semantic version release image is deployed, based
on a semver `ImagePolicy`. This approach can work in Production if you know the
caveats.

(However, for a few reasons this "naive" approach is potentially somewhat
problematic, as subsequent examples will elaborate with specific detail.)

##### Atomic (Non-naïve) Releases

### Git tag-based SemVer Automation

* `ex04-atomic-git-semver-tag-automation/` -
  [link](https://github.com/kingdonb/github-actions-demo/tree/main/apps/podinfo/ex04-atomic-git-semver-tag-automation)
This is perhaps the easiest approach to conceptualize. If:

```
  - our application uses semver tags
  - and we maintain a copy of the latest deployment manifests inside of the source repository
```

... then we can easily ask Flux to use those semantic Git tags to install the
latest release version directly from the application repository.

See how this approach is offloading some responsibility without really ceding
any control. ("The app dev team should be responsible for delivery.")

We can use a Kustomize overlay to patch and make some local changes, without touching the upstream.

### HelmRelease with HelmRepository, SemVer Range

* `ex05-atomic-helmrelease-from-helmrepo/` -
  [link](https://github.com/kingdonb/github-actions-demo/tree/main/apps/podinfo/ex05-atomic-helmrelease-from-helmrepo#readme)
This approach is more complicated to set up, mainly because you will need to publish your charts to a Helm Repository.

The Helm Repository is Helm's native artifact repository, and it works better
with Helm features like rollback and versioning. This is more in line with the
normal experience of using Helm by itself; we first connect to a Helm
repository, and download the index of all published versions of the Chart.

We choose a version to use at install time, and declaratively pass values in
via `HelmRelease.spec.values`.

This works much like any Helm user does imperatively with `helm upgrade --set`
or `helm install --values`. Now, about those values...

### Best Example - HelmRelease with Kustomize ConfigMap Generator

* `ex06-helmrelease-from-gitrepo-with-gitvalues/` -
  [link](https://github.com/kingdonb/github-actions-demo/tree/main/apps/podinfo/ex06-helmrelease-from-gitrepo-with-gitvalues)

Say we have decided to use a `GitRepository` to host our Helm chart, and we
decided we want to store our `values` there as well. Actually, that's not given
(you might use this example with a `HelmRepository` and it works just fine.)

This approach is for the team who wants to keep a `values.yaml` in Git,
alongside of the `HelmRelease`. The example shows how to generate a configmap
from `values.yaml` and incorporate it into your `HelmRelease`. We also show
maintaining a configmap which defines the version to install, so we can
substitute from it.

This can be useful for tracking the version, even if it is non-functional as
explained before (the `HelmRelease.spec.chart.version` is ineffective when used
with a `GitRepository`.)

One could easily regain the function and incorporate an `ImageUpdateAutomation`
here, by switching to a `HelmRepository`. You can use
[variable substitution](https://fluxcd.io/docs/components/kustomize/kustomization/#variable-substitution)
to drive the latest `HelmChart` with the latest image, this might be useful if
you want to update the App version without changing the Helm chart.

But remember, that's `ImageUpdate` and this is a Helm chart. Do not cross the
streams!

(Note: there is a very specific and narrow use case when you might actually
want to combine these two, in other words, in order to use `ImageUpdateAutomation`
to drive `HelmRelease` upgrades. What conditions must be satisfied in order to
make this work, is left as an exercise for the reader.)

## GitHub Actions

For the GitHub Actions examples, see:

#### podinfo application repository

* [podinfo repository link](https://github.com/kingdonb/podinfo/)
* [workflows](https://github.com/kingdonb/podinfo/tree/master/.github/workflows#readme)

##### Bonus Edition: Manifest and Boilerplate Generation

ex07-helmrelease-from-gitrepo-with-gitspec/
ex08-image-automation-without-boilerplate/
ex09-helmrelease-gitrepo-automated-imagely/
ex10-git-monorepo-helmchart-successfully/
