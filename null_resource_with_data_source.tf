terraform {
  required_version = ">=0.11.0"
}

variable "name" {
  description = "name"
  default = "Roger"
}

resource "null_resource" "write_file" {
  provisioner "local-exec" {
    command = "echo ${var.name} > README.md"
  }
  triggers {
    name = "${var.name}"
  }
}

data "null_data_source" "read_file" {
  inputs = {
    name = "${file("README.md")}"
  }
  depends_on = ["null_resource.write_file"]
}

output "name" {
  value = "${data.null_data_source.read_file.outputs["name"]}"
}
