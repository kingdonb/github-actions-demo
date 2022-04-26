# VSCode Extension for Flux with Lima k8s

## Walkthrough of Demo Part 1

* Let's show how to set up K8s and talk about what `$PS1` you have in your terminal
* Walkthrough installing the extension - finding prerelease builds in GitHub
* Walkthrough installing Flux onto the temporary cluster
* How does this differ from using Flux Bootstrap

#### Aside for Flux Bootstrap

A word about Flux Bootstrap - this is where Flux is managing Flux. There are projects
like Azure Arc and Flux's Operator Hub entry, managed services which provide Flux for
your cluster. You can enable Azure addons or Flux with another addon manager, but that
is not Flux managing Flux – it's a service provided by a third party.

Many of these, or most of these such services will likely also be Open Source, but not
all necessarily will, as the license of Flux does not prohibit building Flux into any
closed-source or proprietary product.

## Walkthrough of Demo Part 2

* Can I still get the experience of Flux Bootstrap - Yes, absolutely
* How to follow a tutorial guide - also covers "which guides do I need"
  * List of important guides in order to have the full Flux experience
  * The Flux Editor Extension is not a one-man band - UI of Flux is Notifications
* Roadmap to VSCode Extension's possible future development
  * Limitations of the VSCode extension's model in program capabilities
  * List of top upcoming features in Flux (and where the Editor Extension is going next)
* Let's show some examples on Flux with the VSCode Editor Extension

### Preamble

* Disclaimer/confession: I still don't really like using VScode

I think that many people in the audience are heavy terminal users like myself
I have my terminal set up "just so" and it is very important to how I work
If you have not configured your editor to work how you like, you probably won't like using it

We're going to try to get over this hurdle together, (don't hesitate to lob suggestions at me
if you notice that I'm doing something the hard way – I am learning VScode it's still hard rn!)

I think that I can get to like using VScode, but it will take some configuration and time

* Font is 'M PLUS 1  Code' - just learning about Command Palette (had to look up how to spell Palette)
* Even in the editor, setting up your shell right is half the battle

If you don't get this right, even if you've never had this right before, I feel confident
that you won't like using it either. So spend some time on this, if you haven't already!

#### Things to install via Homebrew or otherwise

```
(⎈ |adm@k8s:default):~ (macos-homebrew *+|u+1)$ brew list|grep -i bash
bash
bash-completion
bash-completion@2

(⎈ |adm@k8s:default):~ (macos-homebrew *+|u+1)$ brew list|grep kube
kube-ps1
kubernetes-cli

(⎈ |adm@k8s:default):~ (macos-homebrew *+|u+1)$ bash --version
GNU bash, version 5.1.16(1)-release (aarch64-apple-darwin21.1.0)
```

* git bash - `git-prompt.sh` from [git/git//contrib/completion](https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh)
* kube ps1 - You might need to adjust your `PS1` to get all this to fit on one line

```
$ echo $PS1
\n$(kube_ps1):\[\033[34m\]\w\[\033[31m\]$(__git_ps1)\[\033[00m\]\$
```

I'm serious now
We're gonna crank the font size way up, so get any extraneous noise out of your shell prompt

##### Important shell setting (aside):
```
HISTSIZE=
HISTFILESIZE=
HISTCONTROL=ignoreboth
```

Rely on `.bash_history`! (Does anyone else still use bash or is it all ZSH now?)
Whatever shell you use, make sure that history is preserved beyond 1000 lines
if you want to rely on <kbd>Ctrl</kbd><kbd>R</kbd> for search history like I do.

##### View git branches in context with each other

Learn to read the git graph, so you can learn to leave a tidy git graph when you merge your commits with others.

I added this to my `~/.gitconfig` and ever since `git l` has changed my life:
```
[alias]
        l = log --date-order --date=iso --graph --full-history --all --pretty=format:'%x08%x09%C(red)%h %C(cyan)%ad%x08%x08%x08%x08%x08%x08%x08%x08%x08%x08%x08%x08%x08%x08%x08 %C(bold blue)%aN%C(reset)%C(bold yellow)%d %C(reset)%s'
        co = checkout
```

#### Recap

Step one is get your shell set up properly

Know what is in your PS1 variable

Step two is

You need tab completion

kubectl offers tab completion
helm offers tab completion

###### One Last Editor Hint

```
alias k=kubectl
complete -F __start_kubectl k
```
Make sure your `.bash_aliases` is loaded after 

(az cli offers tab completion)
flux CLI offers tab completion also

#### Why should I use the Flux CLI?

Tab completion is useful for generating resources

The VSCode Extension UI does not generate Flux resources.

You will want to generate valid Flux resources,
there are half a dozen important CRDs that you will want to know how to make for using Flux.
We will go over a few today.

With that out of the way, this is an editor-focused demo,
we will start clicking around and see what options we can find in the Extension tab

OK, enough talk now

### Start Kubernetes

First, let's bring up our Kubernetes cluster (You can use kind, k3d, anything else... I am using lima)

```
mkdir -p /tmp/lima/qemu-lima-via-homebrew && cd $_
wget https://raw.githubusercontent.com/lima-vm/lima/ae3e43ef9339b3e20c272f4d99865a9a784c9246/examples/k8s.yaml
# I'm using a slightly older k8s.yaml from lima-vm/lima because Ubuntu 22.04 apparently broke the Kubernetes.
limactl start k8s.yaml
USER=kingdonb

mkdir -p "/Users/$USER/.lima/k8s/conf"
export KUBECONFIG="/Users/$USER/.lima/k8s/conf/kubeconfig.yaml"
limactl shell k8s sudo cat /etc/kubernetes/admin.conf >$KUBECONFIG

### Install GitOps Extension

(Ed: walk through installing the GitOps extension)

* [Packaging and Installation](https://github.com/weaveworks/vscode-gitops-tools#packaging-and-installation)
* [Releases and Pre-releases](https://github.com/weaveworks/vscode-gitops-tools/releases)

### Install Flux (Enable GitOps)

The first step is to verify that Flux can run on your cluster.

```
(⎈ |adm@k8s:default):~/gha-demo (main|u=)$ flux check --pre
► checking prerequisites
✗ flux 0.29.3 <0.29.4 (new version is available, please upgrade)
✔ Kubernetes 1.23.6 >=1.20.6-0
✔ prerequisites checks passed
```

If you don't have Flux installed yet, don't worry! The editor extension can help.

If you have Homebrew, and want Flux to keep updated, better to install it this way:

```
$ brew install fluxcd/tap/flux
```

The VScode extension currently doesn't update Flux. It can install the Flux CLI for
you though, in case you don't have Homebrew.

(Ed: Add a screenshot of "Install Flux")

Feature request: `flux check --pre` should be parsed and the editor should notify
you when your `flux` CLI is outdated, with some configurability around silencing.

#### Uninstall Flux

This is not how we wanted to install Flux. We wanted Flux to manage itself, since
we won't depend on any service like Operator Lifecycle Manager or Addon Manager,
or Azure Arc, to manage our Flux installation and keep it hermetically sealed off
where we don't need to look at it, or think about it, or interact with it other
than to opt into upgrades, and keep ahead of breaking changes that might creep in.

We want to manage Flux with GitOps, like everything else we're going to do on our
clusters after the initial setup of CNI, CRI, CSI are all completed, and management
of the control plane of the cluster is squared away, we want to manage Flux just as
we manage our other infrastructure and applications, with manifests in Git and via
GitOps as defined by the GitOps Working Group and [OpenGitOps](https://opengitops.dev).

### Bootstrap Flux

* [https://fluxcd.io/docs/](https://fluxcd.io/docs/)
* [Core Concepts](https://fluxcd.io/docs/concepts/)
* [Get Started](https://fluxcd.io/docs/get-started/)
* [Installation (Bootstrapping)](https://fluxcd.io/docs/installation/)

You will find specific guides there for these environments:

* AWS CodeCommit
* Azure DevOps
* Bitbucket Server and Data Center
* GitHub.com and GitHub Enterprise
* GitLab.com and GitLab Enterprise

...or, you can use a Generic Git server.

I'll be using my personal GitHub account, and I'll be forking an example repo that
I've developed for WOUG demos. It's based on Image Update Automation but we won't
be seeing any Image Automation today, as visualizing Image Update resources is not
yet supported in the VScode Extension. We can still demo the important features.

#### Working from an Example

```
GITHUB_USER=yebyen
GITHUB_SOURCE_UPSTREAM=https://github.com/kingdonb/github-actions-demo
GITHUB_SOURCE_FORKED=https://github.com/yebyen/gha-demo
```

I have shortened the repository name for my fork, to conserve screen real-estate.

You can bootstrap from an https URL, but Flux will always ask your permission to
create a Read/Write deploy token unless you have set GITHUB_TOKEN and exported it.

Besides creating a PAT in the way prescribed by Flux docs, you can also use gh cli
for a token which does not expire or create a scoped lifetime for your deploy keys.

```
$ gh auth login
? What account do you want to log into? GitHub.com
? What is your preferred protocol for Git operations? SSH
? Upload your SSH public key to your GitHub account? /Users/kingdonb/.ssh/id_ed25519-yebyen.pub
? How would you like to authenticate GitHub CLI? Login with a web browser

! First copy your one-time code: 17FC-E232
Press Enter to open github.com in your browser...
✓ Authentication complete.
- gh config set -h github.com git_protocol ssh
✓ Configured git protocol
✓ Uploaded the SSH key to your GitHub account: /Users/kingdonb/.ssh/id_ed25519-yebyen.pub
✓ Logged in as yebyen
```

Now you can use `yq` to harvest the GitHub token, it won't expire like a PAT that
you set up for yourself. (Beware the lifecycle of deploy keys created via PAT!)

```
$ go install github.com/mikefarah/yq/v4@latest
$ ~/go/bin/yq '."github.com".oauth_token' ~/.config/gh/hosts.yml
```

This part is very dangerous, and it's assumed you understand the implications of
handling this GH CLI-generated OAuth2 token which does not expire.

It could be understated, the risks which are possible and the priority that Flux
assigns to keeping Flux users safe through behavior built around safe defaults.

Flux wants to constrain its permissions to either read-only or read-write for a
single repository, by default it will do this using a deploy key. It's read-only
for us today. We can change the URL to a public git repository if we're prepared
for the implications of that. (No secrets should be stored unencrypted, and our
encryption keys need to be protected somehow! Either KMS or another solution.)

Let's bootstrap Flux now:

```
flux bootstrap github       \
  --context=k8s             \
  --owner=${GITHUB_USER}    \
  --repository=gha-demo     \
  --branch=main             \
  --personal                \
  --path=clusters/lima-k8s
```

If you are working on a repository that you have already bootstrapped, you can
repeat this step even if your cluster is old or new, you can bootstrap again with
the same options and this is idempotent. However you should be aware that Flux may
overwrite `gotk-components.yaml` and `gotk-sync.yaml` when you do this, so we mark
them up with warnings at the top of the file that say:

```
# This manifest was generated by flux. DO NOT EDIT.
```

You can make any changes in `kustomization.yaml`

Here's how to override the bootstrap URL with another one by patching

(We do this to avoid the need to use a deploy key of any kind with a public repo.)

This way you can install Flux from Git without involving your Git provider in the
authentication of the cluster.

When your Flux manifests are how you want them to look, go ahead and run:

```
kustomize build flux-system --reorder=none | kubectl apply -f -
```

This way you can avoid running `flux bootstrap` again, but still get the main
ideals of a bootstrap installation (where Flux manages itself and Git is the
single source of truth for Flux and everything underneath it!)

#### What's Next

So you have a minimally bootstrapped Flux installation on your cluster.

* Can I still get the experience of Flux Bootstrap - Yes, absolutely
* How to follow a tutorial guide - also covers "which guides do I need"
  * List of important guides in order to have the full Flux experience
  * The Flux Editor Extension is not a one-man band - UI of Flux is Notifications

##### What else can we do?

Since we have a bare Flux installation now that does not do anything besides managing
itself, we can move on ahead now to setting up our important infrastructure and apps.

* Learn about [Repository Structure](https://fluxcd.io/docs/guides/repository-structure/)
* Install (GitHub) Commit Status Notifications
* Install (Slack) Alert Notification Provider
* Enable monitoring with Prometheus
* Enable Alert-manager, monitor Flux reconcilers

* Configure some additional Kustomizations and/or GitRepos
* Configure Prometheus alerts to notify Slack
* Configure Webhook Receivers
* Configure SOPS and create a root key for the cluster
* Configure some persistent disks to survive the cluster

Using the VScode extension for Flux is not an end-around learning how to operate
it and how the features can be configured.

We can go down any of these roads if we have time and interest!

##### Reminder:

* Roadmap to VSCode Extension's possible future development
  * Limitations of the VSCode extension's model in program capabilities
  * List of top upcoming features in Flux (and where the Editor Extension is going next)
* Let's show some examples on Flux with the VSCode Editor Extension

The examples are in the repository root. Copy from `clusters/rancher` to make them go!
Or try to replicate these results by tab completing with the generators

Eg.

```
$ flux create source git --url https://github.com/kingdonb/podinfo podinfo
$ flux create kustomization --path ./deploy/helm-git --source GitRepository/podinfo podinfo
```
