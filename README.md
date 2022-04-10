### Welcome to the GitHub Actions demo

This is the cluster management or "config" repository. Kubernetes YAMLs go into the various subdirectories found here.

`clusters/rancher` - I'm using k3s and Rancher Desktop for this example, because it provides Traefik
with svclb out of the box. 😎

#### How to Use

I recommend you fork this repository as well as [kingdonb/podinfo](https://github.com/podinfo),
then try to follow the breadcrumbs I've left with each example and make them work on your own.
Another option is to bootstrap an empty repository and then copy these examples into your own repo.

You can install these examples on any Kubernetes cluster that can provision `Services` of
`type: LoadBalancer`. To get started, bootstrap your cluster with Flux as follows, and be sure to
include the extra controllers for the Image Update functionality. These instructions assume you're
working on a fork and I'll attempt to guide you through each step without too much difficulty.

#### Bootstrapping the examples

If you are already above the novice level Flux user, you may be tempted to skip to the end. These
examples build on each other. 

Set the target cluster or context to your own cluster, and any other details based on your own info:

```
flux bootstrap github            \
  --context=k3d-testclu          \
  --owner=${GITHUB_USER}         \
  --repository=github-actions-demo   \
  --branch=main                      \
  --personal                         \
  --path=clusters/rancher            \
  --components-extra=image-automation-controller,image-reflector-controller
```

Then, find the `tenants.yaml` file and uncomment each tenant one-by-one as you follow along with the
examples in the document linked immediately below.

See:

* `apps/podinfo` - The main examples are here. Find the `README.md` file in each for details about it.
  There is also a high-level overview of each example with links at the [top level](/apps/podinfo).

Once your cluster is bootstrapped, you are meant to start reading here 👆👀👋 don't get lost! Good luck.

#### Acknowledgement and Thanks

This repository is a demonstration of several Flux update automation techniques that can be used with
GitHub Actions as shown, or practically any CI system. Thanks for your attention, and I hope you enjoy!

Thanks Weaveworks for hosting (the YouTube link is [here](https://www.youtube.com/watch?v=cR2eCMbiZg4).)

##### PAST: Meetup on Thursday, February 24, 2022

* [GitOps with GitHub Actions and Flux by Kingdon Barrett](https://www.meetup.com/Weave-User-Group/events/284000198/)

### `tl;dr`:

Put your GitHub username in an env variable `GITHUB_USER`, fork this repo, then run:

```
flux bootstrap github              \
  --context=rancher-desktop        \
  --owner=${GITHUB_USER}           \
  --repository=github-actions-demo \
  --branch=main                    \
  --personal                       \
  --path=clusters/rancher          \
  --components-extra=image-automation-controller,image-reflector-controller
```

#### Other Notes

The structure of this repository is based on:

[Flux Multi Tenancy](https://github.com/fluxcd/flux2-multi-tenancy)

If you are totally new to Flux, this demo may not cover all concepts well (so start here instead):

* [Flux - the GitOps family of projects](https://fluxcd.io/)
* [Flux Docs](https://fluxcd.io/docs/)
* [Flux Core Concepts](https://fluxcd.io/docs/concepts/)
* [Get Started with Flux](https://fluxcd.io/docs/get-started/)

If you've seen our Get Started examples before, a basic Helm and Kustomize example with Staging and Production follows:

* [Flux Helm/Kustomize Example](https://github.com/fluxcd/flux2-kustomize-helm-example)

The `podinfo` examples in this repository show a few different methods of automating delivery with Flux.

The Podinfo repository drives GitHub Actions. This is a combined demonstration of GitHub Actions and Flux.

Find the podinfo fork that I have marked up with those examples [here](https://github.com/kingdonb/podinfo/tree/master/.github/workflows#readme).

#### Other Resources

##### PAST: AKS Meetup on Thursday, April 7, 2022

* [GitOps with Flux on AKS](https://www.youtube.com/watch?v=hoD5-I4DjNY)
