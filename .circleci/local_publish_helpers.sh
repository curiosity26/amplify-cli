#!/bin/bash

custom_registry_url=http://localhost:4873
default_verdaccio_package=verdaccio@5.1.2

function startLocalRegistry {
  # Start local registry
  tmp_registry_log=`mktemp`
  echo "Registry output file: $tmp_registry_log"
  (cd && nohup npx ${VERDACCIO_PACKAGE:-$default_verdaccio_package} -c $1 &>$tmp_registry_log &)
  # Wait for Verdaccio to boot
  grep -q 'http address' <(tail -f $tmp_registry_log)
}

function loginToLocalRegistry {
  # Login so we can publish packages
  (cd && npx npm-auth-to-token@1.0.0 -u user -p password -e user@example.com -r "$custom_registry_url")
}

function unsetNpmRegistryUrl {
  # Restore the original NPM and Yarn registry URLs
  npm set registry "https://registry.npmjs.org/"
  yarn config set registry "https://registry.npmjs.org/"
}

function unsetSudoNpmRegistryUrl {
  # Restore the original NPM and Yarn registry URLs
  sudo npm set registry "https://registry.npmjs.org/"
  sudo yarn config set registry "https://registry.npmjs.org/"
}

function changeNpmGlobalPath {
  mkdir -p ~/.npm-global
  npm config set prefix '~/.npm-global'
  export PATH=~/.npm-global/bin:$PATH
}

function changeSudoNpmGlobalPath {
  mkdir -p ~/.npm-global-sudo
  npm config set prefix '~/.npm-global-sudo'
  export PATH=~/.npm-global/bin:$PATH
}

function setNpmRegistryUrlToLocal {
  # Set registry to local registry
  npm set registry "$custom_registry_url"
  yarn config set registry "$custom_registry_url"
}

function setSudoNpmRegistryUrlToLocal {
  # Set registry to local registry
  sudo npm set registry "$custom_registry_url"
  sudo yarn config set registry "$custom_registry_url"
}
