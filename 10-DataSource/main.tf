output "os-version" {
  value = data.local_file.content
}
data "local_file" "os" {
  filename = "/etc/os-release"
}