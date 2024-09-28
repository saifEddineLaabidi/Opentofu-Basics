# resource "random_id" "test_id" {
#   byte_length = 8
# }

# import {
#   to = random_id.test_id
#   id = "Y2FpOGV1Mkk"
# }

# output "id" {
#   value = random_id.test_id.b64_url
# }

variable "server_ids" {
  type = list(string)
}

resource "random_id" "test_id" {
  byte_length = 8
  count = 2
}

import {
  to = random_id.test_id[tonumber(each.key)]
  id = each.value
  for_each = {
    for idx, item in var.server_ids: idx => item
  }
}

output "id" {
  value = random_id.test_id.*.b64_url
}