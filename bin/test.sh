#!/bin/bash

data=$(curl -H "Authorization: token ${GH_TOKEN}" -s -d @- https://api.github.com/graphql << GQL
{ "query": "

    {
      repository(owner: \"idrop\", name: \"cloudwatch-metrics\") {
        packages(first: 1) {
          nodes {
            versions(first: 100) {
              nodes {
                version
              }
            }
          }
        }
      }
    }

" }
GQL
)

echo $data | jq -r ''[.data.repository.packages.nodes[].versions.nodes[].version]