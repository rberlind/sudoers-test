terraform {
  required_version = ">=0.11.0"
}

variable "name" {
  description = "name"
  default = "Roger"
}

variable "filename" {
  description = "file name"
  default = "name.txt"
}

resource "null_resource" "write_file" {
  /*provisioner "local-exec" {
    command = "cp ${var.filename} ~/temp.txt"
  }*/
  provisioner "local-exec" {
    command = "echo ${var.name} > ${var.filename}"
  }
  provisioner "local-exec" {
    command = "pwd"
  }
  provisioner "local-exec" {
    command = "ls"
  }
  triggers {
    name = "${var.name}"
  }
}

data "null_data_source" "read_file" {
  inputs = {
    #name = "${file("${var.filename}")}"
    name = "Roger"
  }
  depends_on = ["null_resource.write_file"]
}

resource "null_resource" "restore_sudoers" {
  /*provisioner "local-exec" {
    command = "cp ~/temp.txt ~"
  }*/
  # This is just to make sure that restore_sudoers is done after read_file
  provisioner "local-exec" {
    command = "echo ${data.null_data_source.read_file.outputs["name"]}"
  }
}

output "name" {
  value = "${data.null_data_source.read_file.outputs["name"]}"
}
