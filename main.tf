//
// Module: terraform-aws-sqs
//
module "enable" {
  source  = "devops-workflow/boolean/local"
  version = "0.1.2"
  value   = "${var.enable}"
}

module "enable_dlq" {
  source  = "devops-workflow/boolean/local"
  version = "0.1.2"
  value   = "${var.enable_dlq}"
}

module "dlq_only" {
  source  = "devops-workflow/boolean/local"
  version = "0.1.2"
  value   = "${var.dlq_only}"
}

module "labels" {
  source        = "appzen-oss/labels/null"
  version       = "0.2.0"
  attributes    = "${var.attributes}"
  component     = "${var.component}"
  delimiter     = "${var.delimiter}"
  enabled       = "${module.enable.value}"
  environment   = "${var.environment}"
  monitor       = "${var.monitor}"
  names         = "${var.sqs_queues}"
  namespace-env = "${var.namespace-env}"
  namespace-org = "${var.namespace-org}"
  organization  = "${var.organization}"
  owner         = "${var.owner}"
  product       = "${var.product}"
  service       = "${var.service}"
  tags          = "${var.tags}"
  team          = "${var.team}"
}

# TODO: add KMS support $$
#     kms_master_key_id                 = "alias/aws/xxx"
#     kms_data_key_reuse_period_seconds = 300 (60 - 86400)

resource "aws_sqs_queue" "queue_deadletter" {
  count                      = "${module.enable.value && module.enable_dlq.value && (var.dlq_arn == "" || module.dlq_only.value) ? length(module.labels.id) : 0}"
  name                       = "${module.labels.id[count.index]}-dlq"
  delay_seconds              = "${var.dlq_delay_seconds != "" ? var.dlq_delay_seconds : var.delay_seconds}"
  max_message_size           = "${var.dlq_max_message_size != "" ? var.dlq_max_message_size : var.max_message_size}"
  message_retention_seconds  = "${var.dlq_message_retention_seconds != "" ? var.dlq_message_retention_seconds : var.message_retention_seconds}"
  policy                     = "${var.dlq_policy != "" ? var.dlq_policy : var.policy}"
  receive_wait_time_seconds  = "${var.dlq_receive_wait_time_seconds != "" ? var.dlq_receive_wait_time_seconds : var.receive_wait_time_seconds}"
  visibility_timeout_seconds = "${var.dlq_visibility_timeout_seconds != "" ? var.dlq_visibility_timeout_seconds : var.visibility_timeout_seconds}"
  sqs_managed_sse_enabled    = "${var.sqs_managed_sse_enabled}"

  tags = "${merge(
    module.labels.tags[count.index],
    map("Name", "${module.labels.id[count.index]}-dlq")
  )}"
}

resource "aws_sqs_queue" "queue" {
  count                      = "${module.enable.value && ! module.enable_dlq.value ? length(module.labels.id) : 0}"
  name                       = "${module.labels.id[count.index]}"
  delay_seconds              = "${var.delay_seconds}"
  max_message_size           = "${var.max_message_size}"
  message_retention_seconds  = "${var.message_retention_seconds}"
  policy                     = "${var.policy}"
  receive_wait_time_seconds  = "${var.receive_wait_time_seconds}"
  visibility_timeout_seconds = "${var.visibility_timeout_seconds}"
  sqs_managed_sse_enabled    = "${var.sqs_managed_sse_enabled}"
  tags                       = "${module.labels.tags[count.index]}"
}

resource "aws_sqs_queue" "queue_with_dlq" {
  count                      = "${module.enable.value && module.enable_dlq.value && ! module.dlq_only.value ? length(module.labels.id) : 0}"
  name                       = "${module.labels.id[count.index]}"
  delay_seconds              = "${var.delay_seconds}"
  max_message_size           = "${var.max_message_size}"
  message_retention_seconds  = "${var.message_retention_seconds}"
  policy                     = "${var.policy}"
  receive_wait_time_seconds  = "${var.receive_wait_time_seconds}"
  visibility_timeout_seconds = "${var.visibility_timeout_seconds}"
  sqs_managed_sse_enabled    = "${var.sqs_managed_sse_enabled}"
  tags                       = "${module.labels.tags[count.index]}"
  redrive_policy             = "{\"deadLetterTargetArn\":\"${var.dlq_arn != "" ? var.dlq_arn : element(concat(aws_sqs_queue.queue_deadletter.*.arn, list("")), count.index)}\",\"maxReceiveCount\":${var.max_receive_count}}"
}
