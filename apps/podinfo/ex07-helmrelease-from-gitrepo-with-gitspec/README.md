#### The solution for Example 7 is derived from:

[Manage Helm Releases: Refer to values in ConfigMaps generated with Kustomize](https://fluxcd.io/docs/guides/helmreleases/#refer-to-values-in-configmaps-generated-with-kustomize)

and Example 6 which precededed this one. Also, a conversation I had with Steve Richards
on the CNCF slack, where we came up with this idea. It's not really novel or surprising
unless you haven't yet been exposed to all the required features to make this example.

##### Pros and Cons of Examples 4 thru 6

In Example 6, we generated a configmap from a simple YAML file that lives in the tenant.
Using features of SIG-CLI Kustomize, each change to the configmap creates a new resource
with a unique name that was automatically updated in the HelmRelease.spec name reference
so that a change in `spec.valuesFrom.name` could trigger an immediate upgrade of the HR.

This way, the Kustomization enforces the HelmRelease each time it gets reconciled. There
should be no significant gap between the timing when the tenant Kustomization upstream
finished reconciling, and when the HelmRelease downstream notices the difference in its
ConfigMap that triggers an immediate queueing for upgrade via the Helm Controller.

In Example 4, we use GitRepository with SemVer automation which has one glaring issue:
the mere presence of a new Git tag does not signal that CI finished successfully, or if
an image will be ready to deploy; only that the CI build should have started.

Furthermore, the automation from Example 4 fails another one of our requirements: the
config repo should always be updated with a commit before a new change deploys, so that
failure can be handled more easily in the config repo by finding and reverting a change
that went out when things started blowing up.

##### Improvements for Example 7

We haven't built any canaries, so we'll be monitoring releases and rollbacks are on us
whenever the metrics we are tracking indicate that a release needs to be rolled back.

In a dev or staging environment it may be appropriate to deploy the latest commit from
the master branch, however we'd prefer if our production environment only updated when
a new tag has been intentionally created, that passed CI build and validation. Then it
is released as a tagged container image and chart, and can finally be deployed.

Since we will control releases of both the app and the chart, while this is not always
guaranteed, we can promise to keep Chart.yaml `version` and `appVersion` synced together,
with each new version, adorning the merge commit on the master branch with a matching
SemVer Git tag, and in that same breath updating appVersion in the chart to match the
new tag that represents a release.

This could be the signal to deploy a new release. Flux is configured to get the latest
tag, and we can infer when ImagePolicy finds a new image, that it represents the latest
successful release that has been tagged and pushed.

##### Take a Flying Leap

So from the presence of a new Image tag, we can infer there must be a matching Git tag!
This use is an abuse of Flux's ImageUpdateAutomation that we can tolerate, because in a
future version of Flux we expect to include OCI support for manifests and configuration
artifacts that can make this semi-strange construction more natural and obvious.

The GitRepository resource is configured to fetch from the new tag as soon as the image
is made available by CI. This should always work, if publishing happens at the end of a
successful CI pipeline. (Publishing a release to a repository should be the last step.)

##### Stronger Separation of Concerns for Tenancy

Another improvement that we can make is to usurp control of what version is deployed
away from the app repo and tenant, and make it centrally controlled from where a root
Flux Kustomization deploys this tenant instead. The tenant cedes this control to the
policy owners, who can be platform team or other central authority who are empowered
to make decisions about which release is in production, and what policies are used to
promote new releases as well as whether a release automation is enabled or disabled.

To simplify: we have designed a shared authority model where application teams decide
when a new release is made, and the platform team can lazily promote a latest release
according to established policy directives, or they can manually curate and determine
when a release version ought to be pinned and/or un-pinned.

By doing this in a shared repo, the decision and policy can be made transparent and
easily updated at any time in either an automated way or with a manual Pull Request.

A large part of the release configuration is effectively divorced from the tenancy.
The application team can define the default configuration inside of the application,
merge in any special configuration when the app is loaded as a tenant, and set the
version which can be maintained centrally, upstream from where tenants are created.
