#!/bin/bash

_user=
_auth=

curl \
  -X POST \
  -H "Authorization: bearer $_auth" \
  -H "Accept: application/vnd.github.packages-preview+json" \
  -d '{"query":"{ user(login: \"$_user\") { registryPackagesForQuery(first: 10, query:\"is:private\") { totalCount nodes { nameWithOwner versions(first: 10) { nodes { id version } } } } }}"}' \
  https://api.github.com/graphql
