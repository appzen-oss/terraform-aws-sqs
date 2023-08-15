//
// Module: terraform-aws-sqs
//

# TODO: add KMS support $$
#     kms_master_key_id                 = "alias/aws/xxx"
#     kms_data_key_reuse_period_seconds = 300 (60 - 86400)

resource "aws_sqs_queue" "queue_deadletter" {
  count                      = var.enable && var.enable_dlq && (var.dlq_arn == "" || var.dlq_only) ? length(var.sqs_queues) : 0
  name                       = "${var.environment}-${var.sqs_queues[count.index]}-dlq"
  delay_seconds              = var.dlq_delay_seconds != "" ? var.dlq_delay_seconds : var.delay_seconds
  sqs_managed_sse_enabled    = var.sqs_managed_sse_enabled
  max_message_size           = var.dlq_max_message_size != "" ? var.dlq_max_message_size : var.max_message_size
  message_retention_seconds  = var.dlq_message_retention_seconds != "" ? var.dlq_message_retention_seconds : var.message_retention_seconds
  policy                     = var.dlq_policy != "" ? var.dlq_policy : var.policy
  receive_wait_time_seconds  = var.dlq_receive_wait_time_seconds != "" ? var.dlq_receive_wait_time_seconds : var.receive_wait_time_seconds
  visibility_timeout_seconds = var.dlq_visibility_timeout_seconds != "" ? var.dlq_visibility_timeout_seconds : var.visibility_timeout_seconds
  tags                       = {"Name":"${var.sqs_queues[count.index]}-dlq"}
}

resource "aws_sqs_queue" "queue" {
  count                      = var.enable && ! var.enable_dlq ? length(var.sqs_queues) : 0
  name                       = "${var.environment}-${var.sqs_queues[count.index]}"
  delay_seconds              = var.delay_seconds
  sqs_managed_sse_enabled    = var.sqs_managed_sse_enabled
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  policy                     = var.policy
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  tags                       = {"Name":var.sqs_queues[count.index]}
}

resource "aws_sqs_queue" "queue_with_dlq" {
  count                      = var.enable && var.enable_dlq && ! var.dlq_only ? length(var.sqs_queues) : 0
  name                       = "${var.environment}-${var.sqs_queues[count.index]}"
  delay_seconds              = var.delay_seconds
  sqs_managed_sse_enabled    = var.sqs_managed_sse_enabled
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  policy                     = var.policy
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  redrive_policy             = "{\"deadLetterTargetArn\": \"${aws_sqs_queue.queue_deadletter.*.arn[count.index]}\",\"maxReceiveCount\":${var.max_receive_count}}"
  tags                       = {"Name":var.sqs_queues[count.index]}
}
