variable "kafka_bootstrap_servers" {
  description = "Kafka bootstrap servers"
  type        = list(string)
  default     = ["localhost:9092"]
}

variable "default_replication_factor" {
  description = "Default replication factor for topics"
  type        = number
  default     = 1
}

variable "default_partitions" {
  description = "Default number of partitions for topics"
  type        = number
  default     = 3
}

variable "default_retention_ms" {
  description = "Default retention time in milliseconds"
  type        = string
  default     = "604800000" # 7 days
}

variable "topics" {
  description = "Map of topics to create"
  type = map(object({
    partitions         = number
    replication_factor = number
    retention_ms       = string
    cleanup_policy     = string
  }))
  default = {}
}