curl -H "Authorization: bearer ${TOKEN}" -X POST -d " \
 { \
   \"query\": \"query { viewer { login }}\" \
 } \
" https://api.github.com/graphql

graphqlQuery() {
  local query="$1"
  shift

  curl -s -H "Authorization: bearer $INPUT_TOKEN" -X POST -d '{"query":"'"$query"'"}' 'https://api.github.com/graphql'
}
listPackageVersions() {
  local g="$1"
  shift
  local a="$1"
  shift

  local query="$(
    cat <<EOF | sed 's/"/\\"/g' | tr '\n\r' ' '
query {
    repository(owner:"$USERNAME", name:"$REPOSNAME"){
        packages(names:"$g.$a",first:1) {
            nodes {
                versions(first:100) {
                    nodes {
                        version
                    }
                }
            }
        }
    }
}
EOF
  )"
  graphqlQuery "$query" | jq -r '.data.repository.packages.nodes[0].versions.nodes[].version'
}
