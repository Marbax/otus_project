provider "google" {
  version = "1.20.0"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_project_metadata_item" "default" {
  key   = "ssh-keys"
  value = "appuser:${file(var.public_key_path)}"
}

module "app" {
  source           = "../modules/app"
  public_key_path  = "${var.public_key_path}"
  private_key_path = "${var.private_key_path}"
  zone             = "${var.zone}"
  app_disk_image   = "${var.app_disk_image}"
  count_app        = "${var.count_app}"
  db_local_ip      = "${module.db.db_local_ip}"
  environment      = "${var.environment}"
}

module "db" {
  source           = "../modules/db"
  public_key_path  = "${var.public_key_path}"
  private_key_path = "${var.private_key_path}"
  zone             = "${var.zone}"
  db_disk_image    = "${var.db_disk_image}"
  count_db         = "${var.count_db}"
  environment      = "${var.environment}"
}

module "vpc" {
  source        = "../modules/vpc"
  source_ranges = "${var.source_ranges}"
  environment   = "${var.environment}"
}
