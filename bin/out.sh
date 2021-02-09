#!/usr/bin/env bash

set -e

cwd="$(cd "$(dirname "$0")" && pwd)"

cd "$1"

# shellcheck disable=SC1090
# load config
. "$cwd"/config


export AWS_PAGER=""
aws cloudwatch put-metric-data --namespace "$NAMESPACE" --metric-name "$METRIC" --value 1 --unit Count --dimensions "$DIMENSIONS"

log "$GREEN$wrote metric $METRIC"

echo '{"version":{"ref":"none"}}'
exit 0
