config=$(cat)

# todo what is this
echo $config > /tmp/source_vars

export AWS_ACCESS_KEY_ID=$(echo $config | jq -r ".source.aws_access_key_id")
export AWS_SECRET_ACCESS_KEY=$(echo $config | jq -r ".source.aws_secret_access_key")
export AWS_DEFAULT_REGION=$(echo $config | jq -r ".source.region")

NAMESPACE=$(echo $config | jq -r ".source.namespace")
METRIC=$(echo $config | jq -r ".source.metric")

DIMENSIONS=$(build_job_name="$BUILD_JOB_NAME",build_pipeline_name="$BUILD_PIPELINE_NAME")


RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

log() {
  args=("$@")
  echo -e "${args[@]}${NC}" 1>&2
}