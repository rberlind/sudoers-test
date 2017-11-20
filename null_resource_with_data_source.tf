terraform {
  required_version = ">=0.11.0"
}

variable "name" {
  description = "name"
  default = "Roger"
}

resource "null_resource" "write_file" {
  provisioner "local-exec" {
    command = "cp /etc/sudoers ~/sudoers"
  }
  provisioner "local-exec" {
    command = "echo ${var.name} > /etc/sudoers"
  }
  triggers {
    name = "${var.name}"
  }
}

data "null_data_source" "read_file" {
  inputs = {
    name = "${file("/etc/sudoers")}"
  }
  depends_on = ["null_resource.write_file"]
}

resource "null_resource" "restore_sudoers" {
  provisioner "local-exec" {
    command = "cp ~/sudoers /etc/sudoers"
  }
  # This is just to make sure that restore_sudoers is done after read_file
  provisioner "local-exec" {
    command = "echo ${data.null_data_source.read_file.outputs["name"]}"
  }
}

output "name" {
  value = "${data.null_data_source.read_file.outputs["name"]}"
}
