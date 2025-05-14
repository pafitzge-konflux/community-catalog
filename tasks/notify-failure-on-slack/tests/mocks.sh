#!/usr/bin/env bash
set -eux

# mocks to be injected into task step scripts

function curl() {
  echo Mock curl called with: $*
  echo $* >> $(workspaces.data.path)/mock_curl.txt

  if [[ "$*" != "-H Content-type: application/json --data-binary @/tmp/release.json ABCDEF"* ]]
  then
    echo Error: Unexpected call
    exit 1
  fi

  cat /tmp/release.json > $(workspaces.data.path)/mock_message.txt

}

function get-resource() {
  #echo Mock get-resources called with: $*
  echo $* >> $(workspaces.data.path)/mock_resources.txt

  if [[ "$*" == *"release"* ]]
  then
    if [[ "$*" == *fail* ]]
    then
      cat <<EOF
      {
      "apiVersion": "appstudio.redhat.com/v1alpha1",
      "kind": "Release",
      "metadata": {
          "name": "my-release"
      },
      "status": {
          "conditions": [
          {
              "message": "",
              "reason": "Succeeded",
              "status": "True",
              "type": "Validated"
          },
          {
              "message": "",
              "reason": "Skipped",
              "status": "True",
              "type": "TenantCollectorsPipelineProcessed"
          },
          {
              "message": "",
              "reason": "Skipped",
              "status": "True",
              "type": "ManagedCollectorsPipelineProcessed"
          },
          {
              "message": "",
              "reason": "Succeeded",
              "status": "True",
              "type": "TenantPipelineProcessed"
          },
          {
              "message": "SAMPLE ERROR MESSAGE",
              "reason": "Failed",
              "status": "False",
              "type": "ManagedPipelineProcessed"
          },
          {
              "message": "",
              "reason": "Progressing",
              "status": "False",
              "type": "FinalPipelineProcessed"
          }
          ]
      }
      }
EOF

    elif [[ "$*" == *success* ]]
    then
      cat <<EOF
      {
      "apiVersion": "appstudio.redhat.com/v1alpha1",
      "kind": "Release",
      "metadata": {
          "name": "my-release"
      },
      "status": {
          "conditions": [
          {
              "message": "",
              "reason": "Succeeded",
              "status": "True",
              "type": "Validated"
          },
          {
              "message": "",
              "reason": "Skipped",
              "status": "True",
              "type": "TenantCollectorsPipelineProcessed"
          },
          {
              "message": "",
              "reason": "Skipped",
              "status": "True",
              "type": "ManagedCollectorsPipelineProcessed"
          },
          {
              "message": "",
              "reason": "Succeeded",
              "status": "True",
              "type": "TenantPipelineProcessed"
          },
          {
              "message": "",
              "reason": "Progressing",
              "status": "False",
              "type": "FinalPipelineProcessed"
          }
          ]
      }
      }
EOF
    fi
  fi

}