output "deadletter_queues" {
  description = "Dead letter queue URLs"
  value       = "${compact(concat(aws_sqs_queue.queue_deadletter.*.id, list("")))}"
}
output "deadletter_queues_arns" {
  description = "Dead letter queue ARNs"
  value       = "${compact(concat(aws_sqs_queue.queue_deadletter.*.arn, list("")))}"
}

output "queue_arns" {
  description = "Queue ARNs"
  value = "${compact(concat(aws_sqs_queue.queue.*.arn, list("")))}"
}

output "queue_names" {
  description = "Queue full names. Use for looking up queue ID"
  value       = "${module.labels.id}"
}

output "queue_name_bases" {
  description = "Queue base names. Use for looking up queue ID"
  value       = "${var.sqs_queues}"
}

output "queues" {
  description = "Queue URLs"
  value       = "${compact(concat(aws_sqs_queue.queue.*.id, aws_sqs_queue.queue_with_dlq.*.id, list("")))}"
}
