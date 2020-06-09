#!/bin/bash
#set +x
IFS=$'\n'
REG_PASS="hub:password"
HDR='Accept: application/vnd.docker.distribution.manifest.v2+json'
REG_URI=https://hub.domain.com:9999/v2
HUBNAME=appl_registry_1

function hubhelp {
        echo hubrepolist ,  hubtaglist reponame , hubimagerm repo tag, hubclean
}
function hubrepolist {
          curl -u $REG_PASS -H \'$HDR\' $REG_URI/_catalog
                }

function hubtaglist {
          if [[ -z $1 ]]; then
              echo "Usage: hubtaglist REPO e.g. imagerm nginx-prod"
          else
              curl -u $REG_PASS -H \'$HDR\' $REG_URI/$1/tags/list
          fi
        }

function hubimagerm {
          if [[ -z $1 || -z $2 ]]; then
             echo "Usage: hubimagerm REPO TAG, e.g. hubimagerm nginx-prod 55"
          else
             SHAD=$(curl -D- -s -u  $REG_PASS  -H 'Accept: application/vnd.docker.distribution.manifest.v2+json' $REG_URI/$1/manifests/$2 | grep docker-content-digest | sed 's/docker-content-digest: //;s/\r$//' )
             curl -s -u  $REG_PASS  -H 'Accept: application/vnd.docker.distribution.manifest.v2+json' -XDELETE "$REG_URI/$1/manifests/$SHAD" > /dev/null 2>&1
          fi
        }
function hubclean {
        docker exec $HUBNAME bin/registry garbage-collect  /etc/docker/registry/config.yml
}
