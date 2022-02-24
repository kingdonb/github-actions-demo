### Welcome to the GitHub Actions demo

This is the cluster management or "config" repository. Kubernetes YAMLs go into the various subdirectories found here.

`clusters/rancher` - I'm using k3s and Rancher Desktop for this example, because it provides Traefik with svclb out of the box. 😎

You can install these examples on any Kubernetes cluster that can provision `Services` of `type: LoadBalancer`.

See:

* `apps/podinfo` - The main examples are here. Find the `README.md` file in each for details about it. There is also a high-level
  overview of each example with links at the [top level](/apps/podinfo).

This repository is a demonstration of several Flux update automation techniques. Thanks for your attention, and I hope you enjoy!

Thanks Weaveworks for hosting (the YouTube link will go [here][FIXME] when it's posted.)

##### Meetup on Thursday, February 24, 2022

* [GitOps with GitHub Actions and Flux by Kingdon Barrett](https://www.meetup.com/Weave-User-Group/events/284000198/)

#### Other Notes

The structure of this repository is based on:

[Flux Multi Tenancy](https://github.com/fluxcd/flux2-multi-tenancy)

If you are totally new to Flux, apologies as this demo is probably too advanced (so start here instead):

* [Flux - the GitOps family of projects](https://fluxcd.io/)
* [Flux Docs](https://fluxcd.io/docs/)
* [Flux Core Concepts](https://fluxcd.io/docs/concepts/)
* [Get Started with Flux](https://fluxcd.io/docs/get-started/)

If you've seen our Get Started examples before, a basic Helm and Kustomize example with Staging and Production follows:

* [Flux Helm/Kustomize Example](https://github.com/fluxcd/flux2-kustomize-helm-example)

The `podinfo` examples in this repository show a few different methods of automating delivery with Flux.

The Podinfo repository drives GitHub Actions. This is a combined demonstration of GitHub Actions and Flux.

Find the podinfo fork that I have marked up with those examples [here][FIXME].
