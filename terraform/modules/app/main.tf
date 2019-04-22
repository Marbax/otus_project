resource "google_compute_instance" "app" {
  count = "${var.count_app}"

  # модификатор 0 + индекс (03d разрядность 3)
  name         = "reddit-app-${var.environment}-${format("%02d", count.index+1)}"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-app"]

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "${var.app_disk_image}"
    }
  }

  # depends_on = ["google_compute_instance.db"]

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"

    # использовать static IP для доступа из Интернет
    access_config = {
      nat_ip = "${google_compute_address.app_ip.address}"
    }
  }
  connection {
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = "${file(var.private_key_path)}"
  }
  provisioner "file" {
    source      = "../modules/app/files/puma.service"
    destination = "/tmp/puma.service"
  }
  provisioner "file" {
    source      = "../modules/app/files/deploy.sh"
    destination = "/tmp/deploy.sh"
  }
  # http://thecloudwoman.com/2017/05/how-to-use-a-terraform-list-variable/
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/deploy.sh",
      "/tmp/deploy.sh ${join("\n", var.db_local_ip)}",
    ]
  }
}

resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip-${var.environment}"
}

resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default-${var.environment}"

  # Название сети, в которой действует правило
  network = "default"

  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]

  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["reddit-app"]
}
