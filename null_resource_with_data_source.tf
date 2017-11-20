terraform {
  required_version = ">=0.11.0"
}

variable "name" {
  description = "name"
  default = "Roger"
}

variable "filename" {
  description = "file name"
  default = "README.md"
}

resource "null_resource" "write_file" {
  provisioner "local-exec" {
    command = "cp ${var.filename} README.txt"
  }
  provisioner "local-exec" {
    command = "echo ${var.name} > ${var.filename}"
  }
  triggers {
    name = "${var.name}"
  }
}

data "null_data_source" "read_file" {
  inputs = {
    name = "${file("${var.filename}")}"
  }
  depends_on = ["null_resource.write_file"]
}

resource "null_resource" "restore_sudoers" {
  provisioner "local-exec" {
    command = "cp README.txt README.md"
  }
  # This is just to make sure that restore_sudoers is done after read_file
  provisioner "local-exec" {
    command = "echo ${data.null_data_source.read_file.outputs["name"]}"
  }
}

output "name" {
  value = "${data.null_data_source.read_file.outputs["name"]}"
}
