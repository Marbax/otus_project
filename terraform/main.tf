provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_project_metadata_item" "default" {
  key   = "ssh-keys"
  value = "${var.user}:${file(var.public_key_path)}"
}

resource "google_compute_instance" "crawler" {
  name         = "${var.iname}"
  machine_type = "${var.machine}"
  zone         = "${var.zone}"
  tags         = ["crawler"]

  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  network_interface {
    network = "default"

    access_config {}
  }

  metadata {
    ssh-keys = "${var.user}:${file(var.public_key_path)}"
  }

  connection {
    type        = "ssh"
    user        = "${var.user}"
    agent       = true
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    script = "../src/external_ip.sh"
  }
}

resource "google_compute_firewall" "firewall_admin_net" {
  name    = "crawler-admin-net"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "2222", "9090", "8080", "3000", "5601", "8888", "9093"]
  }

  source_ranges = ["93.126.79.67/32", "${google_compute_instance.crawler.network_interface.0.access_config.0.assigned_nat_ip}/32"]
  target_tags   = ["crawler"]
}

resource "google_compute_address" "app_ip" {
  name = "crawler-app-ip"
}

resource "google_compute_firewall" "firewall_user_net" {
  name = "crawler-user-net"

  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["crawler"]
}
