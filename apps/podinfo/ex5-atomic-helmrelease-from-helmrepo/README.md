### HelmChartTemplateSpec.version semver range automation

This approach is more complicated to set up, mainly because you will need to publish your charts to a Helm Repository. Fortunately, this is not uncharted
territory and we have this guide to refer to: [automate Helm chart repository publishing](https://medium.com/@stefanprodan/automate-helm-chart-repository-publishing-with-github-actions-and-pages-8a374ce24cf4).

In this guide, Stefan Prodan explains how to publish your charts from Git to GitHub Pages, where they can be hosted without deploying any process or
permanent infrastructure.

(Before the presentation and demo, I should have already done this part on my own fork of the `stefanprodan/podinfo` [GitHub Repo](https://github.com/stefanprodan/podinfo).
You can similarly fork Stefan's repository, or copy and hollow it out (or fork my fork). Or... go ahead and do this with your own application, if you already
have your own chart that you are managing in Git.

The leading benefit of this approach is a clean break and reprieve from the issues mentioned in Example 4; we are not depending on the state of a
`GitRepository` and we control what version is deployed with a single resource, the `HelmRepository`. We can separate our image publishing and releasing from
the choice of what release to deploy. Helm is used for more of what it is intended to do.

The Helm Repository is Helm's native artifact repository, and it works better with Helm features like rollback and versioning.

We can also use this together with `ImageUpdateAutomation` as described in [Configure image update for custom resources](https://fluxcd.io/docs/guides/image-update/#configure-image-update-for-custom-resources)

