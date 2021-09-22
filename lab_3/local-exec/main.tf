# local-exec

resource "null_resource" "make-file" {


  provisioner "local-exec" {
      command = "echo '123' > test-file.txt"
  }

  provisioner "local-exec" {
      when = destroy
      command = "echo 'delete' > test-file.txt"
  }
}