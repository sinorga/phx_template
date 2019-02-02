data "digitalocean_image" "phx_template_base" {
  name = "${var.base_image_name}"
}

resource "digitalocean_droplet" "single_node" {
  image  = "${data.digitalocean_image.phx_template_base.image}"
  name   = "phx-template"
  region = "sgp1"
  size   = "s-1vcpu-1gb"

  ssh_keys = [
    "${var.ssh_fingerprint}",
  ]

  connection {
    user        = "root"
    type        = "ssh"
    private_key = "${file(var.pvt_key)}"
    timeout     = "2m"
  }
}

output "Public ip" {
  value = "${digitalocean_droplet.single_node.ipv4_address}"
}
