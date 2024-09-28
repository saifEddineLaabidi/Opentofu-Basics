resource "local_file" "time" {
  filename = "/root/time.txt"
  content = "Time stamp of this file is ${time_static.time_update.id}"

 }
 resource "time_static" "time_update" {
}