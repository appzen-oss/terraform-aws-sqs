//
// Labels variables
//
variable "attributes" {
  description = "Suffix name with additional attributes (policy, role, etc.)"
  type        = list
  default     = []
}

variable "component" {
  description = "TAG: Underlying, dedicated piece of service (Cache, DB, ...)"
  type        = string
  default     = "UNDEF-SQS"
}

variable "delimiter" {
  description = "Delimiter to be used between `name`, `namespaces`, `attributes`, etc."
  type        = string
  default     = "-"
}

variable "environment" {
  description = "Environment (ex: `dev`, `qa`, `stage`, `prod`). (Second or top level namespace. Depending on namespacing options)"
  type        = string
}

variable "monitor" {
  description = "TAG: Should resource be monitored"
  type        = string
  default     = "UNDEF-SQS"
}

variable "namespace-env" {
  description = "Prefix name with the environment. If true, format is: [env]-[name]"
  default     = true
}

variable "namespace-org" {
  description = "Prefix name with the organization. If true, format is: [org]-[env namespaced name]. If both env and org namespaces are used, format will be [org]-[env]-[name]"
  default     = false
}

variable "organization" {
  description = "Organization name (Top level namespace)"
  type        = string
  default     = ""
}

variable "owner" {
  description = "TAG: Owner of the service"
  type        = string
  default     = "UNDEF-SQS"
}

variable "product" {
  description = "TAG: Company/business product"
  type        = string
  default     = "UNDEF-SQS"
}

variable "service" {
  description = "TAG: Application (microservice) name"
  type        = string
  default     = "UNDEF-SQS"
}

variable "tags" {
  description = "A map of additional tags"
  type        = map
  default     = {}
}

variable "team" {
  description = "TAG: Department/team of people responsible for service"
  type        = string
  default     = "UNDEF-SQS"
}

//
// SQS Variables
//
variable "sqs_queues" {
  description = "List of SQS queue base names"
  type        = list
}

variable "enable" {
  description = "Set to false to prevent the module from creating anything"
  type        = bool
  default     = true
}

variable "enable_dlq" {
  description = "Setup dead letter queue"
  type        = bool
  default     = true
}

variable "sqs_managed_sse_enabled" {
  description = "Encrypt SQS"
  type        = bool
  default     = true
}

variable "delay_seconds" {
  description = "The time in seconds that the delivery of all messages in the queue will be delayed"
  type        = number
  default     = 0
}

variable "dlq_arn" {
  description = "Override DLQ with an existing DLQ"
  default     = ""
}
variable "dlq_delay_seconds" {
  description = "Dead letter queue: The time in seconds that the delivery of all messages in the queue will be delayed"
  default     = ""
}

variable "dlq_max_message_size" {
  description = "Dead letter queue: The limit of how many bytes a message can contain before Amazon SQS rejects it. "
  default     = ""
}

variable "dlq_message_retention_seconds" {
  description = "Dead letter queue: The number of seconds Amazon SQS retains a message"
  default     = ""
}

variable "dlq_only" {
  description = "Only create DLQ"
  type        = bool
  default     = false
}
variable "dlq_policy" {
  description = "DLQ IAM Policy"
  default     = ""
}
variable "dlq_receive_wait_time_seconds" {
  description = "The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning"
  default     = "20"
}

variable "dlq_visibility_timeout_seconds" {
  description = "Dead letter queue: The visibility timeout for the queue"
  default     = ""
}

variable "max_message_size" {
  description = "The limit of how many bytes a message can contain before Amazon SQS rejects it. "
  default     = "262144"
}

variable "max_receive_count" {
  description = ""
  default     = "20"
}

variable "message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message"
  default     = "1209600"
}
variable "policy" {
  description = "Queue IAM Policy"
  default     = ""
}
variable "receive_wait_time_seconds" {
  description = "The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning"
  default     = "20"
}

variable "visibility_timeout_seconds" {
  description = "The visibility timeout for the queue"
  default     = "600"
}
