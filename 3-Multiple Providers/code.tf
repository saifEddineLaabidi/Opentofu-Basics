resource "local_file" "iac_code" {
	  filename = "/opt/practice"
	  content = "Setting up infrastructure as code"
}


resource "random_string" "iac_random" {
  length = 10
  min_upper = 5
}
