#!/usr/bin/env bash

cat > snapshot.json << EOF
{
"application": "myapp",
"components": [
    {
    "name": "comp",
    "containerImage": "registry.io/image@sha256:abcdefg",
    "repository": "prod-registry.io/prod-location",
    "source": {
        "git": {
        "revision": "a51005b614c359b17a24317fdb264d76b2706a5a",
        "url": "https://github.com/abc/python-basic"
        }
    },
    "tags": [
        "testtag"
    ]
    }
]
}
EOF

SNAPSHOT_SPEC_FILE=snapshot.json

APPLICATION=$(jq -r '.application' "${SNAPSHOT_SPEC_FILE}")
NUM_COMPONENTS=$(jq '.components | length' "${SNAPSHOT_SPEC_FILE}")

#echo "$APPLICATION" "$NUM_COMPONENTS"

for ((i = 0; i < NUM_COMPONENTS; i++)); do

    COMPONENT=$(jq -c --argjson i "$i" '.components[$i]' "${SNAPSHOT_SPEC_FILE}")
    
    CONTAINER_IMAGE=$(jq -r '.containerImage' <<< "$COMPONENT")
    REPOSTIORY=$(jq -r '.repository' <<< "$COMPONENT")
    IMAGE_TAGS=$(jq '.tags' <<< "$COMPONENT")

    NUM_TAGS=$(jq '.tags | length' <<< "$COMPONENT")

    echo "$NUM_TAGS"

    for tag in $(jq -r '.[]' <<< "$IMAGE_TAGS"); do
        cosign copy -f "$CONTAINER_IMAGE" "$REPOSTIORY:${tag}"
    done

done