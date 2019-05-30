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

resource "aws_sqs_queue" "queue_deadletter" {
  count                      = "${module.enable.value && module.enable_dlq.value ? length(module.labels.id) : 0}"
  name                       = "${module.labels.id[count.index]}-dlq"
  delay_seconds              = "${var.dlq_delay_seconds != "" ? var.dlq_delay_seconds : var.delay_seconds}"
  max_message_size           = "${var.dlq_max_message_size != "" ? var.dlq_max_message_size : var.max_message_size}"
  message_retention_seconds  = "${var.dlq_message_retention_seconds != "" ? var.dlq_message_retention_seconds : var.message_retention_seconds}"
  visibility_timeout_seconds = "${var.dlq_visibility_timeout_seconds != "" ? var.dlq_visibility_timeout_seconds : var.visibility_timeout_seconds}"

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
  visibility_timeout_seconds = "${var.visibility_timeout_seconds}"
  tags                       = "${module.labels.tags[count.index]}"
}

resource "aws_sqs_queue" "queue_with_dlq" {
  count                      = "${module.enable.value && module.enable_dlq.value ? length(module.labels.id) : 0}"
  name                       = "${module.labels.id[count.index]}"
  delay_seconds              = "${var.delay_seconds}"
  max_message_size           = "${var.max_message_size}"
  message_retention_seconds  = "${var.message_retention_seconds}"
  visibility_timeout_seconds = "${var.visibility_timeout_seconds}"
  tags                       = "${module.labels.tags[count.index]}"
  redrive_policy             = "{\"deadLetterTargetArn\":\"${element(aws_sqs_queue.queue_deadletter.*.arn, count.index)}\",\"maxReceiveCount\":\"${var.max_receive_count}\"}"
}
