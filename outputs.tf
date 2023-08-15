output "deadletter_queues" {
  description = "Dead letter queue URLs"
  value       = aws_sqs_queue.queue_deadletter.*.url
}
output "deadletter_queues_arns" {
  description = "Dead letter queue ARNs"
  value       = aws_sqs_queue.queue_deadletter.*.arn
}

output "queue_arns" {
  description = "Queue ARNs"
  value = aws_sqs_queue.queue.*.arn
}

output "queue_name_bases" {
  description = "Queue base names. Use for looking up queue ID"
  value       = var.sqs_queues
}

output "queues" {
  description = "Queue URLs"
  value       = concat(aws_sqs_queue.queue.*.url, aws_sqs_queue.queue_with_dlq.*.url)
}
