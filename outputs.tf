output "deadletter_queues" {
  value = "${compact(concat(aws_sqs_queue.queue_deadletter.*.id, list("")))}"
}

output "queues" {
  value = "${compact(concat(aws_sqs_queue.queue.*.id, aws_sqs_queue.queue_with_dlq.*.id, list("")))}"
}
