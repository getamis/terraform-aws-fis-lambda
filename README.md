terraform-aws-fis-lambda
===

Control aws fault injection service with lambda

## Conponents

- cloudwatch event rule: trigger event with cron
- sns: receive event
- lambda: subscribe event and trigger fis
- fis: a experiment template

## References

- https://aws.amazon.com/blogs/architecture/chaos-testing-with-aws-fault-injection-simulator-and-aws-codepipeline/

