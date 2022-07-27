#!/bin/bash
set -eu

header() {
	echo
	echo "###############################################"
	echo
	echo $*
	echo
}

header "Changing to dev-changes directory"
cd $GIT_DIRECTORY
pwd
ls -la

header "Adding required safe targets"

safe target vault "$VAULT_ADDR" -k
export VAULT_ROLE_ID=$VAULT_ROLE
export VAULT_SECRET_ID=$VAULT_SECRET

header "Installing cf-targets plugin"
cf install-plugin Targets -f

header "Listing addons..."
genesis do $BOSH_DIRECTOR list

header "Cleaning up for future deployments ..."
cf delete-service-broker autoscaler -f
cleanup $BOSH_DIRECTOR-$KIT_SHORTNAME
safe rm -rf secret/exodus/$BOSH_DIRECTOR/$KIT_SHORTNAME``

header "Testing addons..."
genesis do $BOSH_DIRECTOR -- setup-cf-plugin -f
genesis do $BOSH_DIRECTOR -- bind-autoscaler
