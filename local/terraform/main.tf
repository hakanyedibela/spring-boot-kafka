provider "kafka" {
  bootstrap_servers = ["localhost:9092"]

  # Increase timeout for local development
  timeout = 120

  # Skip TLS verification for local development
  skip_tls_verify = true
  tls_enabled     = false
}

# Example topic configurations
resource "kafka_topic" "user_events" {
  name               = "user-events"
  replication_factor = 1
  partitions         = 3

  config = {
    "cleanup.policy"      = "delete"
    "retention.ms"        = "604800000" # 7 days
    "segment.ms"          = "86400000"  # 1 day
    "compression.type"    = "snappy"
    "max.message.bytes"   = "1048576"   # 1MB
  }
}

resource "kafka_topic" "order_events" {
  name               = "order-events"
  replication_factor = 1
  partitions         = 3

  config = {
    "cleanup.policy"      = "delete"
    "retention.ms"        = "604800000"
    "segment.ms"          = "86400000"
    "compression.type"    = "snappy"
  }
}

resource "kafka_topic" "payment_events" {
  name               = "payment-events"
  replication_factor = 1
  partitions         = 3

  config = {
    "cleanup.policy"      = "delete"
    "retention.ms"        = "2592000000" # 30 days
    "segment.ms"          = "86400000"
    "compression.type"    = "snappy"
  }
}

resource "kafka_topic" "notification_events" {
  name               = "notification-events"
  replication_factor = 1
  partitions         = 2

  config = {
    "cleanup.policy"      = "delete"
    "retention.ms"        = "259200000" # 3 days
    "compression.type"    = "snappy"
  }
}

# Compacted topic example (for changelog/state store)
resource "kafka_topic" "user_state" {
  name               = "user-state"
  replication_factor = 1
  partitions         = 3

  config = {
    "cleanup.policy"         = "compact"
    "min.compaction.lag.ms"  = "0"
    "delete.retention.ms"    = "86400000"
    "segment.ms"             = "86400000"
    "compression.type"       = "snappy"
  }
}

# Dead letter queue topic
resource "kafka_topic" "dlq" {
  name               = "dlq-topic"
  replication_factor = 1
  partitions         = 1

  config = {
    "cleanup.policy"      = "delete"
    "retention.ms"        = "2592000000" # 30 days
    "compression.type"    = "snappy"
  }
}

# Output the created topics
output "topics" {
  value = {
    user_events         = kafka_topic.user_events.name
    order_events        = kafka_topic.order_events.name
    payment_events      = kafka_topic.payment_events.name
    notification_events = kafka_topic.notification_events.name
    user_state          = kafka_topic.user_state.name
    dlq                 = kafka_topic.dlq.name
  }
}