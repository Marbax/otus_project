variable project {
  description = "Project ID"
}

variable user {
  description = "Username(ssh)"
  default     = "appuser"
}

variable region {
  description = "Region"
  default     = "europe-west4"
}

variable iname {
  description = "Instance name"
  default     = "crawler"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable zone {
  description = "Instance zone"
  default     = "europe-west4-c"
}

variable machine {
  description = "Machine type"
  default     = "n1-standard-4"
}

variable disk_image {
  description = "Disk image"
}

variable private_key_path {
  description = "Private key path"
}

variable app_disk_image {
  description = "Disk image for app"
  default     = ""
}
