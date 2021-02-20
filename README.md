# Concourse CloudWatch Metrics Resource

[Concourse][concourse] resource for placing an [AWS CloudWatch][cw] metric.

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

The AWS credentials used should have the `Cloudwatch_PutMetricData` policy attached.

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
      tag: 0.2
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
      metric: Failure
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

If the `smoketest-prod` job fails, the CloudWatch metric `Failure` would be put on namespace `SmokeTest` with value `1` and a timestamp of now.

The dimensions set on the metric, given a concourse team named `main`, pipeline named `test-pipeline` and job of `smoketest-prod`, would be:
* build_team_name: `main`
* build_pipeline_name: `test-pipeline`
* build_job_name: `smoketest-prod`

## Testing

Create an AWS access key and secret, and attach a `Cloudwatch_PutMetricData` policy.

Start up the Concourse services locally using the [quick-start][quick-start].

Then set the test pipeline with:
```
fly set-pipeline -t main -p test -c test/test-pipeline.yaml -v aws_access_key_id=<your aws access key> -v aws_secret_access_key=<your access key secret>
```

Now run the `some-test` job, which should fail and send a metric to AWS CloudWatch.

[cw]: https://aws.amazon.com/cloudwatch/
[concourse]: https://concourse-ci.org
[res-meta]: https://concourse-ci.org/implementing-resource-types.html#resource-metadata
[IAM]: http://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html#use-roles-with-ec2
[put-metric-data]: https://docs.aws.amazon.com/cli/latest/reference/cloudwatch/put-metric-data.html
[quick-start]: https://concourse-ci.org/quick-start.html

