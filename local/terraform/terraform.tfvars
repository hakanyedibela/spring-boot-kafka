topics = {
  "analytics-events" = {
    partitions         = 5
    replication_factor = 1
    retention_ms       = "1209600000" # 14 days
    cleanup_policy     = "delete"
  }
  "audit-logs" = {
    partitions         = 3
    replication_factor = 1
    retention_ms       = "2592000000" # 30 days
    cleanup_policy     = "delete"
  }
  "customer-profile" = {
    partitions         = 3
    replication_factor = 1
    retention_ms       = "-1" # Infinite retention
    cleanup_policy     = "compact"
  }
}