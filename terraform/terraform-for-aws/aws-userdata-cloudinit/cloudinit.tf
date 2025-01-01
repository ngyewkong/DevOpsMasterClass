# cloud initialization parameters
# to use the init.cfg file
# template_file provider is deprecated -> use templatefile() or file() functions
# data "template_file" "install_apache" {
#   template = file("init.cfg")
# }

# define 
data "cloudinit_config" "install_apache_config" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = file("init.cfg")
  }
}
