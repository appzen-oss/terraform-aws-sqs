module "example" {
  source      = "../../"
  sqs_queues  = ["queue01", "queue02"]
  environment = "testing"
}
