provider "kafka" {
  bootstrap_servers = var.kafka_bootstrap_servers

  timeout         = 120
  skip_tls_verify = true
  tls_enabled     = false
}

# Create topics from variables
resource "kafka_topic" "dynamic_topics" {
  for_each = var.topics

  name               = each.key
  replication_factor = each.value.replication_factor
  partitions         = each.value.partitions

  config = {
    "cleanup.policy"   = each.value.cleanup_policy
    "retention.ms"     = each.value.retention_ms
    "compression.type" = "snappy"
  }
}

# Predefined topics
resource "kafka_topic" "user_events" {
  name               = "user-events"
  replication_factor = var.default_replication_factor
  partitions         = var.default_partitions

  config = {
    "cleanup.policy"      = "delete"
    "retention.ms"        = var.default_retention_ms
    "segment.ms"          = "86400000"
    "compression.type"    = "snappy"
    "max.message.bytes"   = "1048576"
  }
}

resource "kafka_topic" "order_events" {
  name               = "order-events"
  replication_factor = var.default_replication_factor
  partitions         = var.default_partitions

  config = {
    "cleanup.policy"   = "delete"
    "retention.ms"     = var.default_retention_ms
    "segment.ms"       = "86400000"
    "compression.type" = "snappy"
  }
}

resource "kafka_topic" "payment_events" {
  name               = "payment-events"
  replication_factor = var.default_replication_factor
  partitions         = var.default_partitions

  config = {
    "cleanup.policy"   = "delete"
    "retention.ms"     = "2592000000"
    "segment.ms"       = "86400000"
    "compression.type" = "snappy"
  }
}

resource "kafka_topic" "notification_events" {
  name               = "notification-events"
  replication_factor = var.default_replication_factor
  partitions         = 2

  config = {
    "cleanup.policy"   = "delete"
    "retention.ms"     = "259200000"
    "compression.type" = "snappy"
  }
}

resource "kafka_topic" "user_state" {
  name               = "user-state"
  replication_factor = var.default_replication_factor
  partitions         = var.default_partitions

  config = {
    "cleanup.policy"        = "compact"
    "min.compaction.lag.ms" = "0"
    "delete.retention.ms"   = "86400000"
    "segment.ms"            = "86400000"
    "compression.type"      = "snappy"
  }
}

resource "kafka_topic" "dlq" {
  name               = "dlq-topic"
  replication_factor = var.default_replication_factor
  partitions         = 1

  config = {
    "cleanup.policy"   = "delete"
    "retention.ms"     = "2592000000"
    "compression.type" = "snappy"
  }
}

# Outputs
output "topics" {
  description = "List of all created topics"
  value = merge(
    {
      user_events         = kafka_topic.user_events.name
      order_events        = kafka_topic.order_events.name
      payment_events      = kafka_topic.payment_events.name
      notification_events = kafka_topic.notification_events.name
      user_state          = kafka_topic.user_state.name
      dlq                 = kafka_topic.dlq.name
    },
    { for k, v in kafka_topic.dynamic_topics : k => v.name }
  )
}

output "topic_details" {
  description = "Detailed information about all topics"
  value = {
    predefined = {
      user_events = {
        name       = kafka_topic.user_events.name
        partitions = kafka_topic.user_events.partitions
      }
      order_events = {
        name       = kafka_topic.order_events.name
        partitions = kafka_topic.order_events.partitions
      }
      payment_events = {
        name       = kafka_topic.payment_events.name
        partitions = kafka_topic.payment_events.partitions
      }
    }
    dynamic = {
      for k, v in kafka_topic.dynamic_topics : k => {
        name       = v.name
        partitions = v.partitions
      }
    }
  }
}