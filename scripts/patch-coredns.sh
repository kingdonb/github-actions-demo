#!/usr/bin/env bash

CONFIG_HOME=~/woug/github-actions-demo/config
PUBLICIP=10.17.12.201
PUBLICDNS=img.hephy.pro

read -rd '' coredns_custom << EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: coredns-custom
  namespace: kube-system
data:
  example.server: |
    hephy.pro {
      hosts {
          ${PUBLICIP} ${PUBLICDNS}
          fallthrough
      }
      whoami
    }
EOF

echo "$coredns_custom" > ${CONFIG_HOME}/coredns-custom.yaml
kubectl apply -f ${CONFIG_HOME}/coredns-custom.yaml
kubectl get pods -n kube-system|grep coredns|cut -d\  -f1|xargs kubectl delete pod -n kube-system
