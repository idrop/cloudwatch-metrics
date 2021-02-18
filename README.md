# Concourse CloudWatch Metrics Resource

[Concourse][concourse] resource for placing an AWS CloudWatch metric.

Example use:
> record the rate that scheduled jobs fail, so that alerts can be raised

The resource is a wrapper around the AWS CLI for CloudWatch  [put-metric-data][put-metric-data].

## Source Configuration

* `namespace`: *Required*<br/>Namespace under which to put the metric. Should not start with `AWS/`.
* `metric`: *Required*<br/>The name of the metric to put.
* `aws_access_key_id`: *Optional*<br/>The AWS access key to use when putting the metric.
* `aws_secret_access_key`: *Optional*<br/>The AWS secret key to use when putting the metric.
* `aws_region`: *Optional*<br/>The AWS region for the credentials.

AWS credentials and region configuration above are optional, and  override a Concourse instance using  [AWS credentials
from IAM instance profiles][IAM]. 

## Behaviour

### `check`: not implemented

<hr>

### `in`: not implemented

<hr>

### `out`: Put a metric to CloudWatch
Put a single metric to CloudWatch, on the given namespace, metric name and dimensions.

#### Parameters

All `params` are optional.

* `dimensions`: *Optional*<br/>up to seven key-value pairs to set as dimensions. The dimensions of [resource metadata][res-meta] `BUILD_JOB_NAME`, `BUILD_PIPELINE_NAME` and `BUILD_TEAM_NAME` are always set as dimensions.
* `value`: *Optional*<br/>double to place as a metric, typically `1` or `0`. Default `1`.
* `unit`: *Optional*<br/>unit to assign to the value. Default `None`.

## Example Configuration

### Resource Type

```
resource_types:
  - name: cloudwatch-metrics
    type: docker-image
    source:
      repository: ghcr.io/idrop/cloudwatch-metrics/cloudwatch-metrics
      tag: 0.1
```

### Resource

```
resources:
  - name: smoketest-fails
    type: cloudwatch-metrics
    source:
      aws_region: eu-west-2
      aws_access_key_id: ((aws_access_key_id))
      aws_secret_access_key: ((aws_secret_access_key))
      namespace: SmokeTest
      metric: Failures
```

### Plan

```
jobs:
  - name: smoketest-prod
    plan:
      ........
    on_failure:
      put: smoketest-fails
```

If the job `smoketest-prod` above failed, the CloudWatch metric `Failures` would be put on namespace `SmokeTest` with value `1` and a timestamp of now.

The dimensions, given a concourse team named `main`, pipeline named `test-pipeline` and job of `smoketest-prod`, would be:
* build_team_name: `main`
* build_pipeline_name: `test-pipeline`
* build_job_name: `smoketest-prod`

[concourse]: https://concourse-ci.org
[res-meta]: https://concourse-ci.org/implementing-resource-types.html#resource-metadata
[IAM]: http://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html#use-roles-with-ec2
[put-metric-data]: https://docs.aws.amazon.com/cli/latest/reference/cloudwatch/put-metric-data.html

