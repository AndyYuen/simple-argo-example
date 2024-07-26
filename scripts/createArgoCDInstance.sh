#! /bin/bash

if [ "$#" -ne 1 ]; then
	echo "Usage: $0 namespace"
	exit 1
fi

NAMESPACE=$1

# Create Argo CD instance
cat << EOF | oc  apply -f  -
apiVersion: argoproj.io/v1beta1
kind: ArgoCD
metadata:
  name: ${NAMESPACE}
  namespace: openshift-gitops
spec:
  kustomizeBuildOptions: --enable-helm --enable-alpha-plugins
  rbac:
    defaultPolicy: role:admin
    scopes: '[groups]'
  resourceExclusions: |
    - kinds:
        - TaskRun
  server:
    insecure: true
    route:
      enabled: true
      tls:
        insecureEdgeTerminationPolicy: Redirect
        termination: edge
  sso:
    dex:
      openShiftOAuth: true
    provider: dex
EOF

# Ensure required namespace exists
oc new-project "${NAMESPACE}"
oc label --overwrite namespace "${NAMESPACE}" argocd.argoproj.io/managed-by=openshift-gitops
