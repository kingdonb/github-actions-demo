[https://github.com/SynologyOpenSource/synology-csi](https://github.com/SynologyOpenSource/synology-csi)

NB: The driver is apparently limited to 10 LUNs. Have fun! (More info):

Issue: [SynologyOpenSource/synology-csi#33](https://github.com/SynologyOpenSource/synology-csi/issues/33)

To install this driver, you should already have Flux installed.

run:

```
kustomize build .|kubectl apply -f -
```

This is done for you if you bootstrapped the whole repo, if you do it manually
it likely fails the first time because of a missing tenant namespace and SA.

(Create them from the main clusters/rancher/ tutorial, or create them manually)

You must also handle secrets as in the upstream synology-csi repo:

```bash

SOURCE_PATH="$(pwd)/synology-csi"
git clone https://github.com/SynologyOpenSource/synology-csi "$SOURCE_PATH"
config_file="${SOURCE_PATH}/config/client-info.yml"

kubectl create ns synology-csi
kubectl create secret -n synology-csi generic client-info-secret --from-file="$config_file"
```

(copy from `config/template-client-info.yml` to create `client-info.yml` and
replace the IP and login information with your own Synology NAS login details.)

This will install the configuration from my fork,
[kingdonb/synology-csi](https://github.com/kingdonb/synology-csi). You probably
want to make your own fork, and edit it to reflect your own cluster details. Or
maybe just use mine, IDK. You might not even have one of these awesome Synology
boxes and this will be totally useless for you. (That's why it's intermission!)
