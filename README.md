# Concourse CloudWatch Metrics Resource

Concourse resource for putting AWS CloudWatch metrics.

Created to monitor the rate at which time scheduled smoke tests fail, so that alerts can be raised.

A wrapper around the  [Cloudwatch put-metric-data](https://docs.aws.amazon.com/cli/latest/reference/cloudwatch/put-metric-data.html) CLI.

## Source Configuration

* `namespace`: *Required* Namespace under which to put the metric. Should not start with `AWS/`.
* `metric`: *Required* The name of the metric to put.
* `aws_access_key_id`: *Optional* The AWS access key to use when putting the metric.
* `aws_secret_access_key`: *Optional* The AWS secret key to use when putting the metric.
* `aws_region`: *Optional* The aws region for the credentials.

AWS credentials and region configuration above are optional, and  override a concourse instance  [retrieving AWS credentials
from IAM instance profiles][IAM]. 

[IAM]: http://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html#use-roles-with-ec2

## Behaviour

### `check`: not implemented

### `in`: not implemented

### `out`: Put a metric to CloudWatch
Put a single metric to CloudWatch, on the given namespace, metric name and dimensions.

#### Parameters

All `params` are optional.

* `dimensions`: *Optional* up to seven key-value pairs to set as dimensions. The dimensions of [resource metadata][res-meta] `BUILD_JOB_NAME`, `BUILD_PIPELINE_NAME` and `BUILD_TEAM_NAME` are always set as dimensions.
* `value`: *Optional* double to place as a metric, typically `1` or `0`. Default `1`.
* `unit`: *Optional* unit to assign to the value. Default `None`.

[res-meta]: https://concourse-ci.org/implementing-resource-types.html#resource-metadata

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
      params:
        dimensions:
          foo: bar
```

If the job `smoketest-prod` above failed, the CloudWatch metric `Failures` would be put on namespace `SmokeTest` with value `1` and a timestamp of now.

The dimensions, given a concourse team named `main`, pipeline named `test-pipeline` and job of `smoketest-prod` would be:
* build_team_name: `main`
* build_pipeline_name: `test-pipeline`
* build_job_name: `smoketest-prod`
* foo: `bar`

